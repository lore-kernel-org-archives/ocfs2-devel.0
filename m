From: David Teigland <teigland@redhat.com>
Date: Tue, 23 Feb 2010 15:47:28 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <20100210203527.GB5062@redhat.com>
References: <4B720386.7010301@oracle.com> <20100210193540.GA5062@redhat.com>
	<4B73155C.2000602@oracle.com> <20100210203527.GB5062@redhat.com>
Message-ID: <20100223214728.GH31495@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 10, 2010 at 02:35:27PM -0600, David Teigland wrote:
> On Wed, Feb 10, 2010 at 12:21:48PM -0800, Sunil Mushran wrote:
> > >(7258,3,alternate):__ocfs2_cluster_lock:1426 lock 
> > >M000000000000000003f00400000000, convert from 0 to 3
> > >Feb 10 13:19:39 bull-01 kernel: 
> > >(7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres 
> > >M000000000000000003f00400000000, blocking 5, level 0 type Meta
> > >Feb 10 13:19:39 bull-01 kernel: 
> > >(7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres 
> > >M000000000000000003f00400000000, block 5, level 0, l_block 5, dwn 0
> > >Feb 10 13:19:39 bull-01 kernel: 
> > >(7211,0,dlm_astd):ocfs2_locking_ast:1106 lock 
> > >M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
> > >Feb 10 13:19:39 bull-01 kernel: 
> > >(7258,3,alternate):__ocfs2_cluster_lock:1426 lock 
> > >M000000000000000003f00400000000, convert from 3 to 5
> > 
> > So it requests NL => PR. It gets a BAST with blocking EX
> > before the AST for PR. The last patch added changed the
> > BAST handling to not schedule the downconvert thread if
> > the current lock level was compatible. In this case, because
> > the BAST is before the AST, the lock level is still NL.
> > 
> > One fix would be to take l_requested also into account.
> > As in, schedule the dc thread if the current or the requested
> > lock level is incompat.
> > 
> > But this should be a fsdlm bug. Why is it sending a BAST
> > before the AST? If we do look at the requested lock level and
> > do schedule the down convert thread, we are just buying a
> > little more time for the AST. That's it. The problem from the
> > glue side is that we are expected to handle multiple BASTs.
> > The last patch made it ignore a BAST that was sent after a
> > AST for a drop lock. I'm wondering whether we can sanely handle
> > this in glue.
> > 
> > Thoughts?
> 
> It does sounds suspicious on the dlm side, I'll look into it.

The dlm is indeed sending the bast before the cast.  With the fix
for that (attached), alternate is running fine again.  I'll now get
back to doing some long running tests of make_panic and alternate.

I actually need to split up the fix into a couple different patches
and will then queue them up for the coming merge window.

Dave

-------------- next part --------------
From c781a3af6b7ed69fc3b72c8691f2b13ad7d31ef7 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 17 Feb 2010 16:57:42 -0600
Subject: [PATCH] dlm: callback fixes

- when there are both completion (cast) and blocking (bast) callbacks
  queued, keep track of which was queued first, and deliver that one first

- keep track of the granted mode from the last cast and if the blocking
  mode of the next bast is compatible with it, then don't deliver that bast

- the lock master should send a completion ast for a convert or a request
  before sending basts for the completed convert/request

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c          |   86 ++++++++++++++++++++++++++++++++++++++++--------
 fs/dlm/ast.h          |    2 +-
 fs/dlm/dlm_internal.h |    8 ++++-
 fs/dlm/lock.c         |   69 +++++++++++++++++++++++++++++----------
 fs/dlm/user.c         |    8 +++--
 fs/dlm/user.h         |    2 +-
 6 files changed, 136 insertions(+), 39 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index dc2ad60..777a0c9 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -33,10 +33,10 @@ void dlm_del_ast(struct dlm_lkb *lkb)
 	spin_unlock(&ast_queue_lock);
 }
 
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
+void dlm_add_ast(struct dlm_lkb *lkb, int type, int mode)
 {
 	if (lkb->lkb_flags & DLM_IFL_USER) {
-		dlm_user_add_ast(lkb, type, bastmode);
+		dlm_user_add_ast(lkb, type, mode);
 		return;
 	}
 
@@ -44,10 +44,19 @@ void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
 	if (!(lkb->lkb_ast_type & (AST_COMP | AST_BAST))) {
 		kref_get(&lkb->lkb_ref);
 		list_add_tail(&lkb->lkb_astqueue, &ast_queue);
+		lkb->lkb_ast_first = type;
 	}
+
+	if ((type == AST_COMP) && (lkb->lkb_ast_type & AST_COMP))
+		log_print("repeat cast %d castmode %d lock %x %s",
+			  mode, lkb->lkb_castmode,
+			  lkb->lkb_id, lkb->lkb_resource->res_name);
+
 	lkb->lkb_ast_type |= type;
-	if (bastmode)
-		lkb->lkb_bastmode = bastmode;
+	if (type == AST_BAST)
+		lkb->lkb_bastmode = mode;
+	else
+		lkb->lkb_castmode = mode;
 	spin_unlock(&ast_queue_lock);
 
 	set_bit(WAKE_ASTS, &astd_wakeflags);
@@ -59,9 +68,9 @@ static void process_asts(void)
 	struct dlm_ls *ls = NULL;
 	struct dlm_rsb *r = NULL;
 	struct dlm_lkb *lkb;
-	void (*cast) (void *astparam);
-	void (*bast) (void *astparam, int mode);
-	int type = 0, bastmode;
+	void (*castfn) (void *astparam);
+	void (*bastfn) (void *astparam, int mode);
+	int type, first, bastmode, castmode, do_bast, do_cast, last_castmode;
 
 repeat:
 	spin_lock(&ast_queue_lock);
@@ -75,17 +84,64 @@ repeat:
 		list_del(&lkb->lkb_astqueue);
 		type = lkb->lkb_ast_type;
 		lkb->lkb_ast_type = 0;
+		first = lkb->lkb_ast_first;
+		lkb->lkb_ast_first = 0;
 		bastmode = lkb->lkb_bastmode;
-
+		castmode = lkb->lkb_castmode;
+		castfn = lkb->lkb_astfn;
+		bastfn = lkb->lkb_bastfn;
 		spin_unlock(&ast_queue_lock);
-		cast = lkb->lkb_astfn;
-		bast = lkb->lkb_bastfn;
-
-		if ((type & AST_COMP) && cast)
-			cast(lkb->lkb_astparam);
 
-		if ((type & AST_BAST) && bast)
-			bast(lkb->lkb_astparam, bastmode);
+		do_cast = (type & AST_COMP) && castfn;
+		do_bast = (type & AST_BAST) && bastfn;
+
+		/* Skip a bast if its blocking mode is compatible with the
+		   granted mode of the preceding cast. */
+
+		if (do_bast) {
+			if (first == AST_COMP)
+				last_castmode = castmode;
+			else
+				last_castmode = lkb->lkb_castmode_done;
+
+			if (dlm_modes_compat(bastmode, last_castmode)) {
+				do_bast = 0;
+
+				log_debug(ls, "skip bast ast_type %d ast_first %d lock %x %s",
+					  type, first, lkb->lkb_id, r->res_name);
+				log_debug(ls, "skip bastmode_done %d bastmode %d",
+					  lkb->lkb_bastmode_done, bastmode);
+				log_debug(ls, "skip castmode_done %d castmode %d",
+					  lkb->lkb_castmode_done, castmode);
+				log_debug(ls, "skip last_castmode %d", last_castmode);
+			}
+		}
+
+		if (do_bast && do_cast && (first == AST_BAST)) {
+			log_debug(ls, "first bast %d cast %d type %d "
+				  "lock %x %s", bastmode, castmode, type,
+				  lkb->lkb_id, r->res_name);
+		}
+
+		if (first == AST_COMP) {
+			if (do_cast)
+				castfn(lkb->lkb_astparam);
+			if (do_bast)
+				bastfn(lkb->lkb_astparam, bastmode);
+		} else if (first == AST_BAST) {
+			if (do_bast)
+				bastfn(lkb->lkb_astparam, bastmode);
+			if (do_cast)
+				castfn(lkb->lkb_astparam);
+		} else {
+			log_error(ls, "bad ast_first %d ast_type %d",
+				  first, type);
+		}
+
+		if (do_cast)
+			lkb->lkb_castmode_done = castmode;
+		if (do_bast)
+			lkb->lkb_bastmode_done = bastmode;
 
 		/* this removes the reference added by dlm_add_ast
 		   and may result in the lkb being freed */
diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
index 1b5fc5f..830ae8b 100644
--- a/fs/dlm/ast.h
+++ b/fs/dlm/ast.h
@@ -13,7 +13,7 @@
 #ifndef __ASTD_DOT_H__
 #define __ASTD_DOT_H__
 
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode);
+void dlm_add_ast(struct dlm_lkb *lkb, int type, int mode);
 void dlm_del_ast(struct dlm_lkb *lkb);
 
 void dlm_astd_wake(void);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 826d3dc..305d9d6 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -232,11 +232,17 @@ struct dlm_lkb {
 	int8_t			lkb_status;     /* granted, waiting, convert */
 	int8_t			lkb_rqmode;	/* requested lock mode */
 	int8_t			lkb_grmode;	/* granted lock mode */
-	int8_t			lkb_bastmode;	/* requested mode */
 	int8_t			lkb_highbast;	/* highest mode bast sent for */
+
 	int8_t			lkb_wait_type;	/* type of reply waiting for */
 	int8_t			lkb_wait_count;
 	int8_t			lkb_ast_type;	/* type of ast queued for */
+	int8_t			lkb_ast_first;	/* type of first ast queued */
+
+	int8_t			lkb_bastmode;	/* req mode of queued bast */
+	int8_t			lkb_castmode;	/* gr mode of queued cast */
+	int8_t			lkb_bastmode_done; /* last delivered bastmode */
+	int8_t			lkb_castmode_done; /* last delivered castmode */
 
 	struct list_head	lkb_idtbl_list;	/* lockspace lkbtbl */
 	struct list_head	lkb_statequeue;	/* rsb g/c/w list */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 9c0c1db..bfa3ee6 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -307,7 +307,7 @@ static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 	lkb->lkb_lksb->sb_status = rv;
 	lkb->lkb_lksb->sb_flags = lkb->lkb_sbflags;
 
-	dlm_add_ast(lkb, AST_COMP, 0);
+	dlm_add_ast(lkb, AST_COMP, lkb->lkb_grmode);
 }
 
 static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb *lkb)
@@ -2280,20 +2280,29 @@ static int do_request(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	if (can_be_queued(lkb)) {
 		error = -EINPROGRESS;
 		add_lkb(r, lkb, DLM_LKSTS_WAITING);
-		send_blocking_asts(r, lkb);
 		add_timeout(lkb);
 		goto out;
 	}
 
 	error = -EAGAIN;
-	if (force_blocking_asts(lkb))
-		send_blocking_asts_all(r, lkb);
 	queue_cast(r, lkb, -EAGAIN);
-
  out:
 	return error;
 }
 
+static void do_request_effects(struct dlm_rsb *r, struct dlm_lkb *lkb, int error)
+{
+	switch (error) {
+	case -EAGAIN:
+		if (force_blocking_asts(lkb))
+			send_blocking_asts_all(r, lkb);
+		break;
+	case -EINPROGRESS:
+		send_blocking_asts(r, lkb);
+		break;
+	}
+}
+
 static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error = 0;
@@ -2304,7 +2313,6 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	if (can_be_granted(r, lkb, 1, &deadlk)) {
 		grant_lock(r, lkb);
 		queue_cast(r, lkb, 0);
-		grant_pending_locks(r);
 		goto out;
 	}
 
@@ -2334,7 +2342,6 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		if (_can_be_granted(r, lkb, 1)) {
 			grant_lock(r, lkb);
 			queue_cast(r, lkb, 0);
-			grant_pending_locks(r);
 			goto out;
 		}
 		/* else fall through and move to convert queue */
@@ -2344,20 +2351,33 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		error = -EINPROGRESS;
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
-		send_blocking_asts(r, lkb);
 		add_timeout(lkb);
 		goto out;
 	}
 
 	error = -EAGAIN;
-	if (force_blocking_asts(lkb))
-		send_blocking_asts_all(r, lkb);
 	queue_cast(r, lkb, -EAGAIN);
-
  out:
 	return error;
 }
 
+static void do_convert_effects(struct dlm_rsb *r, struct dlm_lkb *lkb, int error)
+{
+	switch (error) {
+	case 0:
+		grant_pending_locks(r);
+		/* grant_pending_locks also sends basts */
+		break;
+	case -EAGAIN:
+		if (force_blocking_asts(lkb))
+			send_blocking_asts_all(r, lkb);
+		break;
+	case -EINPROGRESS:
+		send_blocking_asts(r, lkb);
+		break;
+	}
+}
+
 static int do_unlock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	remove_lock(r, lkb);
@@ -2402,11 +2422,15 @@ static int _request_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		goto out;
 	}
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_request() calls do_request() on remote node */
 		error = send_request(r, lkb);
-	else
+	} else {
 		error = do_request(r, lkb);
+		/* for remote locks the request_reply is sent
+		   between do_request and do_request_effects */
+		do_request_effects(r, lkb, error);
+	}
  out:
 	return error;
 }
@@ -2417,11 +2441,15 @@ static int _convert_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error;
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_convert() calls do_convert() on remote node */
 		error = send_convert(r, lkb);
-	else
+	} else {
 		error = do_convert(r, lkb);
+		/* for remote locks the convert_reply is sent
+		   between do_convert and do_convert_effects */
+		do_convert_effects(r, lkb, error);
+	}
 
 	return error;
 }
@@ -3191,6 +3219,7 @@ static void receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 	attach_lkb(r, lkb);
 	error = do_request(r, lkb);
 	send_request_reply(r, lkb, error);
+	do_request_effects(r, lkb, error);
 
 	unlock_rsb(r);
 	put_rsb(r);
@@ -3226,15 +3255,19 @@ static void receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
 		goto out;
 
 	receive_flags(lkb, ms);
+
 	error = receive_convert_args(ls, lkb, ms);
-	if (error)
-		goto out_reply;
+	if (error) {
+		send_convert_reply(r, lkb, error);
+		goto out;
+	}
+
 	reply = !down_conversion(lkb);
 
 	error = do_convert(r, lkb);
- out_reply:
 	if (reply)
 		send_convert_reply(r, lkb, error);
+	do_convert_effects(r, lkb, error);
  out:
 	unlock_rsb(r);
 	put_rsb(r);
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index e73a4bb..b49b4cb 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -173,7 +173,7 @@ static int lkb_is_endoflife(struct dlm_lkb *lkb, int sb_status, int type)
 /* we could possibly check if the cancel of an orphan has resulted in the lkb
    being removed and then remove that lkb from the orphans list and free it */
 
-void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
+void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode)
 {
 	struct dlm_ls *ls;
 	struct dlm_user_args *ua;
@@ -206,8 +206,10 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
 
 	ast_type = lkb->lkb_ast_type;
 	lkb->lkb_ast_type |= type;
-	if (bastmode)
-		lkb->lkb_bastmode = bastmode;
+	if (type == AST_BAST)
+		lkb->lkb_bastmode = mode;
+	else
+		lkb->lkb_castmode = lkb->lkb_grmode;
 
 	if (!ast_type) {
 		kref_get(&lkb->lkb_ref);
diff --git a/fs/dlm/user.h b/fs/dlm/user.h
index 1c96864..13684bb 100644
--- a/fs/dlm/user.h
+++ b/fs/dlm/user.h
@@ -9,7 +9,7 @@
 #ifndef __USER_DOT_H__
 #define __USER_DOT_H__
 
-void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int bastmode);
+void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode);
 int dlm_user_init(void);
 void dlm_user_exit(void);
 int dlm_device_deregister(struct dlm_ls *ls);
-- 
1.6.6

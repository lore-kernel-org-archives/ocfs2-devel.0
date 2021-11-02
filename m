Return-Path: <SRS0=iO0D=PV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D73C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 12:30:30 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E8D2604D2
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 12:30:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3E8D2604D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2BePKO001771;
	Tue, 2 Nov 2021 12:30:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c27r5er61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Nov 2021 12:30:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2CGGNZ079785;
	Tue, 2 Nov 2021 12:30:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c1khtdjc9-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Nov 2021 12:30:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mhsvq-00028J-GE; Tue, 02 Nov 2021 05:30:26 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mhsvo-00027x-Dj
	for ocfs2-devel@oss.oracle.com; Tue, 02 Nov 2021 05:30:24 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2CGG57079753
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 12:30:24 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3c1khtdj92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 12:30:24 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A29MXKh028825
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 12:30:22 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c28q3b6nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 12:30:22 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-208-tFW_RAAGNhiXL0JYxEGa9w-1; Tue, 02 Nov 2021 08:30:17 -0400
X-MC-Unique: tFW_RAAGNhiXL0JYxEGa9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1143A19200C0;
	Tue,  2 Nov 2021 12:30:16 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.195.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C46C52B060;
	Tue,  2 Nov 2021 12:30:12 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: cluster-devel@redhat.com
Date: Tue,  2 Nov 2021 13:29:35 +0100
Message-Id: <20211102122945.117744-8-agruenba@redhat.com>
In-Reply-To: <20211102122945.117744-1-agruenba@redhat.com>
References: <20211102122945.117744-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
	ip4:128.17.0.0/20
	ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
	ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21
	ip4:13.110.216.0/22 ip4:13.110.224.0/20 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
	ip4:128.17.0.0/20
	ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
	ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21
	ip4:13.110.216.0/22 ip4:13.110.224.0/20 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v9 07/17] gfs2: Clean up function may_grant
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020073
X-Proofpoint-ORIG-GUID: JurO0uLWNFxCOYynU62H0-g_VzEGoZB4
X-Proofpoint-GUID: JurO0uLWNFxCOYynU62H0-g_VzEGoZB4

Pass the first current glock holder into function may_grant and
deobfuscate the logic there.

While at it, switch from BUG_ON to GLOCK_BUG_ON in may_grant.  To make
that build cleanly, de-constify the may_grant arguments.

We're now using function find_first_holder in do_promote, so move the
function's definition above do_promote.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/glock.c | 119 ++++++++++++++++++++++++++++--------------------
 1 file changed, 69 insertions(+), 50 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e0eaa9cf9fb6..bffd9c20f2de 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -301,46 +301,59 @@ void gfs2_glock_put(struct gfs2_glock *gl)
 }
 
 /**
- * may_grant - check if its ok to grant a new lock
+ * may_grant - check if it's ok to grant a new lock
  * @gl: The glock
+ * @current_gh: One of the current holders of @gl
  * @gh: The lock request which we wish to grant
  *
- * Returns: true if its ok to grant the lock
+ * With our current compatibility rules, if a glock has one or more active
+ * holders (HIF_HOLDER flag set), any of those holders can be passed in as
+ * @current_gh; they are all the same as far as compatibility with the new @gh
+ * goes.
+ *
+ * Returns true if it's ok to grant the lock.
  */
 
-static inline int may_grant(const struct gfs2_glock *gl, const struct gfs2_holder *gh)
-{
-	const struct gfs2_holder *gh_head = list_first_entry(&gl->gl_holders, const struct gfs2_holder, gh_list);
+static inline bool may_grant(struct gfs2_glock *gl,
+			     struct gfs2_holder *current_gh,
+			     struct gfs2_holder *gh)
+{
+	if (current_gh) {
+		GLOCK_BUG_ON(gl, !test_bit(HIF_HOLDER, &current_gh->gh_iflags));
+
+		switch(current_gh->gh_state) {
+		case LM_ST_EXCLUSIVE:
+			/*
+			 * Here we make a special exception to grant holders
+			 * who agree to share the EX lock with other holders
+			 * who also have the bit set. If the original holder
+			 * has the LM_FLAG_NODE_SCOPE bit set, we grant more
+			 * holders with the bit set.
+			 */
+			return gh->gh_state == LM_ST_EXCLUSIVE &&
+			       (current_gh->gh_flags & LM_FLAG_NODE_SCOPE) &&
+			       (gh->gh_flags & LM_FLAG_NODE_SCOPE);
 
-	if (gh != gh_head) {
-		/**
-		 * Here we make a special exception to grant holders who agree
-		 * to share the EX lock with other holders who also have the
-		 * bit set. If the original holder has the LM_FLAG_NODE_SCOPE bit
-		 * is set, we grant more holders with the bit set.
-		 */
-		if (gh_head->gh_state == LM_ST_EXCLUSIVE &&
-		    (gh_head->gh_flags & LM_FLAG_NODE_SCOPE) &&
-		    gh->gh_state == LM_ST_EXCLUSIVE &&
-		    (gh->gh_flags & LM_FLAG_NODE_SCOPE))
-			return 1;
-		if ((gh->gh_state == LM_ST_EXCLUSIVE ||
-		     gh_head->gh_state == LM_ST_EXCLUSIVE))
-			return 0;
+		case LM_ST_SHARED:
+		case LM_ST_DEFERRED:
+			return gh->gh_state == current_gh->gh_state;
+
+		default:
+			return false;
+		}
 	}
+
 	if (gl->gl_state == gh->gh_state)
-		return 1;
+		return true;
 	if (gh->gh_flags & GL_EXACT)
-		return 0;
+		return false;
 	if (gl->gl_state == LM_ST_EXCLUSIVE) {
-		if (gh->gh_state == LM_ST_SHARED && gh_head->gh_state == LM_ST_SHARED)
-			return 1;
-		if (gh->gh_state == LM_ST_DEFERRED && gh_head->gh_state == LM_ST_DEFERRED)
-			return 1;
+		return gh->gh_state == LM_ST_SHARED ||
+		       gh->gh_state == LM_ST_DEFERRED;
 	}
-	if (gl->gl_state != LM_ST_UNLOCKED && (gh->gh_flags & LM_FLAG_ANY))
-		return 1;
-	return 0;
+	if (gh->gh_flags & LM_FLAG_ANY)
+		return gl->gl_state != LM_ST_UNLOCKED;
+	return false;
 }
 
 static void gfs2_holder_wake(struct gfs2_holder *gh)
@@ -380,6 +393,24 @@ static void do_error(struct gfs2_glock *gl, const int ret)
 	}
 }
 
+/**
+ * find_first_holder - find the first "holder" gh
+ * @gl: the glock
+ */
+
+static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	if (!list_empty(&gl->gl_holders)) {
+		gh = list_first_entry(&gl->gl_holders, struct gfs2_holder,
+				      gh_list);
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
 /**
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
@@ -393,14 +424,15 @@ __releases(&gl->gl_lockref.lock)
 __acquires(&gl->gl_lockref.lock)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	struct gfs2_holder *gh, *tmp;
+	struct gfs2_holder *gh, *tmp, *first_gh;
 	int ret;
 
 restart:
+	first_gh = find_first_holder(gl);
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
 		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
 			continue;
-		if (may_grant(gl, gh)) {
+		if (may_grant(gl, first_gh, gh)) {
 			if (gh->gh_list.prev == &gl->gl_holders &&
 			    glops->go_lock) {
 				spin_unlock(&gl->gl_lockref.lock);
@@ -722,23 +754,6 @@ __acquires(&gl->gl_lockref.lock)
 	spin_lock(&gl->gl_lockref.lock);
 }
 
-/**
- * find_first_holder - find the first "holder" gh
- * @gl: the glock
- */
-
-static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
-{
-	struct gfs2_holder *gh;
-
-	if (!list_empty(&gl->gl_holders)) {
-		gh = list_first_entry(&gl->gl_holders, struct gfs2_holder, gh_list);
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
-			return gh;
-	}
-	return NULL;
-}
-
 /**
  * run_queue - do all outstanding tasks related to a glock
  * @gl: The glock in question
@@ -1354,8 +1369,12 @@ __acquires(&gl->gl_lockref.lock)
 		GLOCK_BUG_ON(gl, true);
 
 	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
-		if (test_bit(GLF_LOCK, &gl->gl_flags))
-			try_futile = !may_grant(gl, gh);
+		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
+			struct gfs2_holder *first_gh;
+
+			first_gh = find_first_holder(gl);
+			try_futile = !may_grant(gl, first_gh, gh);
+		}
 		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
 			goto fail;
 	}
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 24 Feb 2014 17:07:01 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix dlm lock migration crash
In-Reply-To: <CAEeiSHV+TVsnwqnsi0u4r=ucBoddo8wD8DcqbsCn1UoA3xjtdg@mail.gmail.com>
References: <1342509026-6170-1-git-send-email-junxiao.bi@oracle.com>	<CAEeiSHVKM7TK0u4Cd_JWVY9Z8bKj3326ay2RG5dqi4z9fXPaHQ@mail.gmail.com>	<5006131A.8010303@oracle.com>	<CAEeiSHXpcU6xXeDzP3nA8jGDnoit-NtZHM2A73hya_9c01Y_mg@mail.gmail.com>	<50076428.2040908@oracle.com>
	<CAEeiSHV+TVsnwqnsi0u4r=ucBoddo8wD8DcqbsCn1UoA3xjtdg@mail.gmail.com>
Message-ID: <530B0BB5.90600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 07/19/2012 09:59 AM, Sunil Mushran wrote:
> Different issues.
>
> On Wed, Jul 18, 2012 at 6:34 PM, Junxiao Bi <junxiao.bi@oracle.com
> <mailto:junxiao.bi@oracle.com>> wrote:
>
>     On 07/19/2012 12:36 AM, Sunil Mushran wrote:
>>     This bug was detected during code audit. Never seen a crash. If
>>     it does hit,
>>     then we have bigger problems. So no point posting to stable.
>
I read a lot of dlm recovery code recently, I found this bug could
happen at the following scenario.

node 1:                                             migrate target node x:
dlm_unregister_domain()
 dlm_migrate_all_locks()
  dlm_empty_lockres()
   select node x as migrate target node
   since there is a node x lock on the granted list.
   dlm_migrate_lockres()
    dlm_mark_lockres_migrating() {
     wait_event(dlm->ast_wq, !dlm_lockres_is_dirty(dlm, res));
<<< node x unlock may happen here, res->granted list can be empty.
     dlm_lockres_release_ast(dlm, res);
    }  
    dlm_send_one_lockres()
                                                  
dlm_process_recovery_data() {
                                                    tmpq is res->granted
list and is empty.
                                                   
list_for_each_entry(lock, tmpq, list) {
                                                     if (lock->ml.cookie
!= ml->cookie)
                                                      lock = NULL;
                                                     else
                                                      break;
                                                    }  
                                                    lock will be invalid
here.
                                                    if (lock->ml.node !=
ml->node)
                                                        BUG() --> crash
here.
                                                   }

Thanks,
Junxiao.
>
>     Our customer can reproduce it. Also I saw you were assigned a
>     similar bug before, see
>     https://oss.oracle.com/bugzilla/show_bug.cgi?id=1220, is it the
>     same BUG?
>>
>>     On Tue, Jul 17, 2012 at 6:36 PM, Junxiao Bi
>>     <junxiao.bi at oracle.com <mailto:junxiao.bi@oracle.com>> wrote:
>>
>>         Hi Sunil,
>>
>>         On 07/18/2012 03:49 AM, Sunil Mushran wrote:
>>>         On Tue, Jul 17, 2012 at 12:10 AM, Junxiao Bi
>>>         <junxiao.bi at oracle.com <mailto:junxiao.bi@oracle.com>> wrote:
>>>
>>>             In the target node of the dlm lock migration, the logic
>>>             to find
>>>             the local dlm lock is wrong, it shouldn't change the
>>>             loop variable
>>>             "lock" in the list_for_each_entry loop. This will cause
>>>             a NULL-pointer
>>>             accessing crash.
>>>
>>>             Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com
>>>             <mailto:junxiao.bi@oracle.com>>
>>>             Cc: stable at vger.kernel.org <mailto:stable@vger.kernel.org>
>>>             ---
>>>              fs/ocfs2/dlm/dlmrecovery.c |   12 +++++++-----
>>>              1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>>             diff --git a/fs/ocfs2/dlm/dlmrecovery.c
>>>             b/fs/ocfs2/dlm/dlmrecovery.c
>>>             index 01ebfd0..0b9cc88 100644
>>>             --- a/fs/ocfs2/dlm/dlmrecovery.c
>>>             +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>>             @@ -1762,6 +1762,7 @@ static int
>>>             dlm_process_recovery_data(struct dlm_ctxt *dlm,
>>>                     u8 from = O2NM_MAX_NODES;
>>>                     unsigned int added = 0;
>>>                     __be64 c;
>>>             +       int found;
>>>
>>>                     mlog(0, "running %d locks for this lockres\n",
>>>             mres->num_locks);
>>>                     for (i=0; i<mres->num_locks; i++) {
>>>             @@ -1793,22 +1794,23 @@ static int
>>>             dlm_process_recovery_data(struct dlm_ctxt *dlm,
>>>                                     /* MIGRATION ONLY! */
>>>                                     BUG_ON(!(mres->flags &
>>>             DLM_MRES_MIGRATION));
>>>
>>>             +                       found = 0;
>>>                                     spin_lock(&res->spinlock);
>>>                                     for (j = DLM_GRANTED_LIST; j <=
>>>             DLM_BLOCKED_LIST; j++) {
>>>                                             tmpq =
>>>             dlm_list_idx_to_ptr(res, j);
>>>                                            
>>>             list_for_each_entry(lock, tmpq, list) {
>>>             -                                       if
>>>             (lock->ml.cookie != ml->cookie)
>>>             -                                               lock = NULL;
>>>             -                                       else
>>>             +                                       if
>>>             (lock->ml.cookie == ml->cookie) {
>>>             +                                               found = 1;
>>>                                                             break;
>>>             +                                       }
>>>                                             }
>>>             -                               if (lock)
>>>             +                               if (found)
>>>                                                     break;
>>>                                     }
>>>
>>>                                     /* lock is always created
>>>             locally first, and
>>>                                      * destroyed locally last.  it
>>>             must be on the list */
>>>             -                       if (!lock) {
>>>             +                       if (!found) {
>>>                                             c = ml->cookie;
>>>                                             mlog(ML_ERROR, "Could
>>>             not find local lock "
>>>                                                            "with
>>>             cookie %u:%llu, node %u, "
>>>
>>>
>>>
>>>         https://oss.oracle.com/git/?p=smushran/linux-2.6.git;a=blobdiff;f=fs/ocfs2/dlm/dlmrecovery.c;h=c881be6043a8c27c26ee44d217fb8ecf1eb37e02;hp=01ebfd0bdad72264b99345378f0c6febe246503d;hb=13279667cc8bbaf901591dee96f762d4aab8b307;hpb=a5ae0116eb56ec7c128e84fe15646a5cb9a8cb47
>>>
>>>
>>>         We had decided to go back to list_for_each().
>>
>>         OK, thank you. It's OK to revert it back for a introduced
>>         bug. But I think you'd better cc stable branch.
>>
>>
>
>
>

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140224/f8596f59/attachment.html 

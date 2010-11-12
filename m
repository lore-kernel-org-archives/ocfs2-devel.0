From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 12 Nov 2010 13:22:08 -0600
Subject: [Ocfs2-devel] [PATCH 1/2] Introduce ocfs2_recover_node
In-Reply-To: <20101112021614.GA2316@laptop.jp.oracle.com>
References: <AANLkTikLJODb51xYJdcs3JmoYvJLETDMpUutxXh8ZpF1@mail.gmail.com>
	<20101112021614.GA2316@laptop.jp.oracle.com>
Message-ID: <AANLkTikzZnCA4aK_tXMLacoFjwQ9aCiuSiZs3nPvJ08G@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,

Thanks for the review.

On Thu, Nov 11, 2010 at 8:16 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> On 10-11-11 19:01, Goldwyn Rodrigues wrote:
>> ocfs2_recover_node is a new data structure to include all information required
>> to recover one node. The structure is maintained as a list in the super block.
>>
>> ocfs2_recover_node replaces the recovery_map
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
>> ---
>> ?fs/ocfs2/journal.c | ?170 +++++++++++++++++++++------------------------------
>> ?fs/ocfs2/journal.h | ? ?9 ++-
>> ?fs/ocfs2/ocfs2.h ? | ? ?3 +-
>> ?fs/ocfs2/super.c ? | ? 16 -----
>> ?4 files changed, 78 insertions(+), 120 deletions(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index faa2303..6c378d6 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -58,8 +58,7 @@ DEFINE_SPINLOCK(trans_inc_lock);
>> ?#define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
>>
>> ?static int ocfs2_force_read_journal(struct inode *inode);
>> -static int ocfs2_recover_node(struct ocfs2_super *osb,
>> - ? ? ? ? ? ? ? ? ? ? ? ? ? int node_num, int slot_num);
>> +static int ocfs2_recover_one_node(struct ocfs2_recover_node *rn);
>> ?static int __ocfs2_recovery_thread(void *arg);
>> ?static int ocfs2_commit_cache(struct ocfs2_super *osb);
>> ?static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota);
>> @@ -179,24 +178,11 @@ void ocfs2_free_replay_slots(struct ocfs2_super *osb)
>>
>> ?int ocfs2_recovery_init(struct ocfs2_super *osb)
>> ?{
>> - ? ? struct ocfs2_recovery_map *rm;
>> -
>> ? ? ? mutex_init(&osb->recovery_lock);
>> ? ? ? osb->disable_recovery = 0;
>> ? ? ? osb->recovery_thread_task = NULL;
>> ? ? ? init_waitqueue_head(&osb->recovery_event);
>> -
>> - ? ? rm = kzalloc(sizeof(struct ocfs2_recovery_map) +
>> - ? ? ? ? ? ? ? ? ?osb->max_slots * sizeof(unsigned int),
>> - ? ? ? ? ? ? ? ? ?GFP_KERNEL);
>> - ? ? if (!rm) {
>> - ? ? ? ? ? ? mlog_errno(-ENOMEM);
>> - ? ? ? ? ? ? return -ENOMEM;
>> - ? ? }
>> -
>> - ? ? rm->rm_entries = (unsigned int *)((char *)rm +
>> - ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? sizeof(struct ocfs2_recovery_map));
>> - ? ? osb->recovery_map = rm;
>> + ? ? INIT_LIST_HEAD(&osb->s_recovery_nodes);
>>
>> ? ? ? return 0;
>> ?}
>> @@ -212,8 +198,6 @@ static int ocfs2_recovery_thread_running(struct
>> ocfs2_super *osb)
>>
>> ?void ocfs2_recovery_exit(struct ocfs2_super *osb)
>> ?{
>> - ? ? struct ocfs2_recovery_map *rm;
>> -
>> ? ? ? /* disable any new recovery threads and wait for any currently
>> ? ? ? ?* running ones to exit. Do this before setting the vol_state. */
>> ? ? ? mutex_lock(&osb->recovery_lock);
>> @@ -226,29 +210,20 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>> ? ? ? ?* complete. */
>> ? ? ? flush_workqueue(ocfs2_wq);
>>
>> - ? ? /*
>> - ? ? ?* Now that recovery is shut down, and the osb is about to be
>> - ? ? ?* freed, ?the osb_lock is not taken here.
>> - ? ? ?*/
>> - ? ? rm = osb->recovery_map;
>> - ? ? /* XXX: Should we bug if there are dirty entries? */
>> -
>> - ? ? kfree(rm);
>> ?}
>
> needs to free ocfs2_recover_nodes in list osb->s_recovery_nodes?
>

Hmm. Good catch.


>>
>> ?static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?unsigned int node_num)
>
> for function names, would you also change all *map* to *node* accordingly?
>
>> ?{
>> - ? ? int i;
>> - ? ? struct ocfs2_recovery_map *rm = osb->recovery_map;
>> + ? ? struct ocfs2_recover_node *rn;
>> + ? ? struct list_head *iter;
>>
>> ? ? ? assert_spin_locked(&osb->osb_lock);
>> -
>> - ? ? for (i = 0; i < rm->rm_used; i++) {
>> - ? ? ? ? ? ? if (rm->rm_entries[i] == node_num)
>> + ? ? list_for_each(iter, &osb->s_recovery_nodes) {
>> + ? ? ? ? ? ? rn = list_entry(iter, struct ocfs2_recover_node, rn_list);
>> + ? ? ? ? ? ? if (rn->rn_node_num == node_num)
>> ? ? ? ? ? ? ? ? ? ? ? return 1;
>> ? ? ? }
>> -
>> ? ? ? return 0;
>> ?}
>>
>> @@ -256,45 +231,36 @@ static int __ocfs2_recovery_map_test(struct
>> ocfs2_super *osb,
>> ?static int ocfs2_recovery_map_set(struct ocfs2_super *osb,
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? unsigned int node_num)
>> ?{
>> - ? ? struct ocfs2_recovery_map *rm = osb->recovery_map;
>> -
>> - ? ? spin_lock(&osb->osb_lock);
>> - ? ? if (__ocfs2_recovery_map_test(osb, node_num)) {
>> - ? ? ? ? ? ? spin_unlock(&osb->osb_lock);
>> - ? ? ? ? ? ? return 1;
>> - ? ? }
>> + ? ? struct list_head *iter;
>> + ? ? struct ocfs2_recover_node *rn = NULL, *trn;
>>
>> - ? ? /* XXX: Can this be exploited? Not from o2dlm... */
>> - ? ? BUG_ON(rm->rm_used >= osb->max_slots);
>> + ? ? trn = kzalloc(sizeof(struct ocfs2_recover_node), GFP_KERNEL);
>>
>
> GFP_NOFS is better in this case?
> NULL check?
>

Yes, I will change that.

>> - ? ? rm->rm_entries[rm->rm_used] = node_num;
>> - ? ? rm->rm_used++;
>> + ? ? spin_lock(&osb->osb_lock);
>> + ? ? list_for_each(iter, &osb->s_recovery_nodes) {
>> + ? ? ? ? ? ? ? ? ? ? rn = list_entry(iter, struct ocfs2_recover_node,
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? rn_list);
>> + ? ? ? ? ? ? ? ? ? ? if (rn->rn_node_num == node_num) {
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? spin_unlock(&osb->osb_lock);
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? kfree(trn);
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? return 1;
>> + ? ? ? ? ? ? ? ? ? ? }
>> + ? ? }
>> + ? ? trn->rn_node_num = node_num;
>> + ? ? trn->rn_osb = osb;
>> + ? ? list_add_tail(&trn->rn_list, &osb->s_recovery_nodes);
>> ? ? ? spin_unlock(&osb->osb_lock);
>>
>> ? ? ? return 0;
>> ?}
>>
>> ?static void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
>> - ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?unsigned int node_num)
>> + ? ? ? ? ? ? ? ? ? ? struct ocfs2_recover_node *rn)
>> ?{
>> - ? ? int i;
>> - ? ? struct ocfs2_recovery_map *rm = osb->recovery_map;
>> -
>> ? ? ? spin_lock(&osb->osb_lock);
>> -
>> - ? ? for (i = 0; i < rm->rm_used; i++) {
>> - ? ? ? ? ? ? if (rm->rm_entries[i] == node_num)
>> - ? ? ? ? ? ? ? ? ? ? break;
>> - ? ? }
>> -
>> - ? ? if (i < rm->rm_used) {
>> - ? ? ? ? ? ? /* XXX: be careful with the pointer math */
>> - ? ? ? ? ? ? memmove(&(rm->rm_entries[i]), &(rm->rm_entries[i + 1]),
>> - ? ? ? ? ? ? ? ? ? ? (rm->rm_used - i - 1) * sizeof(unsigned int));
>> - ? ? ? ? ? ? rm->rm_used--;
>> - ? ? }
>> -
>> + ? ? list_del(&rn->rn_list);
>> ? ? ? spin_unlock(&osb->osb_lock);
>> + ? ? kfree(rn);
>> ?}
>>
>> ?static int ocfs2_commit_cache(struct ocfs2_super *osb)
>> @@ -1092,10 +1058,9 @@ bail:
>> ?static int ocfs2_recovery_completed(struct ocfs2_super *osb)
>> ?{
>> ? ? ? int empty;
>> - ? ? struct ocfs2_recovery_map *rm = osb->recovery_map;
>>
>> ? ? ? spin_lock(&osb->osb_lock);
>> - ? ? empty = (rm->rm_used == 0);
>> + ? ? empty = list_empty(&osb->s_recovery_nodes);
>> ? ? ? spin_unlock(&osb->osb_lock);
>>
>> ? ? ? return empty;
>> @@ -1332,12 +1297,13 @@ void ocfs2_complete_quota_recovery(struct
>> ocfs2_super *osb)
>>
>> ?static int __ocfs2_recovery_thread(void *arg)
>> ?{
>> - ? ? int status, node_num, slot_num;
>> + ? ? int status;
>> ? ? ? struct ocfs2_super *osb = arg;
>> - ? ? struct ocfs2_recovery_map *rm = osb->recovery_map;
>> ? ? ? int *rm_quota = NULL;
>> ? ? ? int rm_quota_used = 0, i;
>> ? ? ? struct ocfs2_quota_recovery *qrec;
>> + ? ? struct list_head *iter;
>> + ? ? struct ocfs2_recover_node *rn = NULL;
>>
>> ? ? ? mlog_entry_void();
>>
>> @@ -1367,20 +1333,21 @@ restart:
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? NULL, NULL);
>>
>> ? ? ? spin_lock(&osb->osb_lock);
>> - ? ? while (rm->rm_used) {
>> + ? ? list_for_each(iter, &osb->s_recovery_nodes) {
>> + ? ? ? ? ? ? rn = list_entry(iter, struct ocfs2_recover_node, rn_list);
>> ? ? ? ? ? ? ? /* It's always safe to remove entry zero, as we won't
>> ? ? ? ? ? ? ? ?* clear it until ocfs2_recover_node() has succeeded. */
>> - ? ? ? ? ? ? node_num = rm->rm_entries[0];
>> ? ? ? ? ? ? ? spin_unlock(&osb->osb_lock);
>> - ? ? ? ? ? ? mlog(0, "checking node %d\n", node_num);
>> - ? ? ? ? ? ? slot_num = ocfs2_node_num_to_slot(osb, node_num);
>> - ? ? ? ? ? ? if (slot_num == -ENOENT) {
>> + ? ? ? ? ? ? mlog(0, "checking node %d\n", rn->rn_node_num);
>> + ? ? ? ? ? ? rn->rn_slot_num = ocfs2_node_num_to_slot(osb, rn->rn_node_num);
>> + ? ? ? ? ? ? if (rn->rn_slot_num == -ENOENT) {
>> ? ? ? ? ? ? ? ? ? ? ? status = 0;
>> ? ? ? ? ? ? ? ? ? ? ? mlog(0, "no slot for this node, so no recovery"
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ?"required.\n");
>> ? ? ? ? ? ? ? ? ? ? ? goto skip_recovery;
>> ? ? ? ? ? ? ? }
>> - ? ? ? ? ? ? mlog(0, "node %d was using slot %d\n", node_num, slot_num);
>> + ? ? ? ? ? ? mlog(0, "node %d was using slot %d\n",
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? rn->rn_node_num, rn->rn_slot_num);
>>
>> ? ? ? ? ? ? ? /* It is a bit subtle with quota recovery. We cannot do it
>> ? ? ? ? ? ? ? ?* immediately because we have to obtain cluster locks from
>> @@ -1388,18 +1355,19 @@ restart:
>> ? ? ? ? ? ? ? ?* then quota usage would be out of sync until some node takes
>> ? ? ? ? ? ? ? ?* the slot. So we remember which nodes need quota recovery
>> ? ? ? ? ? ? ? ?* and when everything else is done, we recover quotas. */
>> - ? ? ? ? ? ? for (i = 0; i < rm_quota_used && rm_quota[i] != slot_num; i++);
>> + ? ? ? ? ? ? for (i = 0; i < rm_quota_used && rm_quota[i] != rn->rn_slot_num;
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? i++);
>> ? ? ? ? ? ? ? if (i == rm_quota_used)
>> - ? ? ? ? ? ? ? ? ? ? rm_quota[rm_quota_used++] = slot_num;
>> + ? ? ? ? ? ? ? ? ? ? rm_quota[rm_quota_used++] = rn->rn_slot_num;
>>
>> - ? ? ? ? ? ? status = ocfs2_recover_node(osb, node_num, slot_num);
>> + ? ? ? ? ? ? status = ocfs2_recover_one_node(rn);
>> ?skip_recovery:
>> ? ? ? ? ? ? ? if (!status) {
>> - ? ? ? ? ? ? ? ? ? ? ocfs2_recovery_map_clear(osb, node_num);
>> + ? ? ? ? ? ? ? ? ? ? ocfs2_recovery_map_clear(osb, rn);
>
> kfree with spinlocked here.
>

What is the problem with that?
In any case, this part of the code moves to thread.

Regards,

-- 
Goldwyn

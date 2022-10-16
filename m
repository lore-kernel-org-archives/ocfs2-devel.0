Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89528C433FE
	for <ocfs2-devel@archiver.kernel.org>; Sun, 16 Oct 2022 23:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EUyXoh0hzogDCJTGwUkQfpUdEQxV7qrBhnWO5BbESmE=;
 b=QJB61FUOPjno7MnMOHo9HbPd3noCcTzzt6Ft8Rlpqq/WLHRhD5oa3kaQEYnJuF69m5wqeo8ajEOR
   KQmJoSwpiC9ZRD9NZzrM6et3DTN8M7aOLiArG/r43ddAcaRGLZuFhpGgt4NlKbHJ3KygNv8GKjDN
   r8BclyjHgYvanTrq2H/t9YIWEn2KM/jMG/a+M4eEQy9jHj9r0Lqf8KyeMJiQt1ZFToUnCRdQ+92R
   oT6qhtEl+AnrGynZzwS1PnlPfVXaUN8CBOa5E4+JyJDfIPABAxPugFTGV644Gn9YyTM7TnfSNsD3
   oHR994cUIG9uZSdP0FPEE0VmKoaEO3WNOvdizw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EUyXoh0hzogDCJTGwUkQfpUdEQxV7qrBhnWO5BbESmE=;
 b=Rq/YzjlmCVustWXRdiNTT+qbWW46d54pBLa9pczlOl/2wd/a8bZqOoia55GDvbpEKnv3J9WoXOKC
   aqv5ev8AOy++dQJXK3GzWdT//K475oRZ7l7uxoZSQ4phKlq42kVfhD5f2s9AhZf7qRPjDjuiqsJm
   BqWo2xOD0n2Att4EVJWhv1Wwen+sMg/nzCxN/dxYBnvLTQGTsvA0HARM+o3kby5Bqf0/nDwWPu5I
   1KIQ5zV/oze0lDOvJU7KYs3ZFW8Ng0Qc4VeVOorpcCJDsOY6OrhngyCpldAyLmR0Wg4NIg59nKSM
   cVd/96NK5RNb6FcfRhDKa4AYbvpRXx5pg1REMg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJV003O7DF16LB0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 16 Oct 2022 23:33:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1665963166; bh=jfh7fNWLQG26T5MsmOC+xYhoA7ZMvYpvVgmi2dlytEU=;
 h=Date:From:To:Subject:In-Reply-To:References:From;
 b=rx2NoIoAn4rTbEusw+NOnC3HlY9Vay9u2DBBcPU1FSJ6szHh3y5OHZw+83bO9E7gw
 ojr6HHos7RqC5xDhKhKkl/m2Xvbh5Pd24UViuYAtV+uAZ2DsHcrCrdmtdJTIah6Smv
 7H9lAF98AJp2+5LscBTnjoHrU9jvFWcRVND8qywA=
Date: Sun, 16 Oct 2022 16:32:45 -0700
To: Joseph Qi <jiangqi903@gmail.com>, ocfs2-devel@oss.oracle.com,
 Wangyan <wangyan122@huawei.com>
Message-id: <20221016163245.786bb7ee9d6cfc952f445642@linux-foundation.org>
In-reply-to: <20200806204910.6fa489d7aabd5c8026f4c704@linux-foundation.org>
References: <d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com>
 <09b83918-89aa-2f5c-bbbf-ea4470386bfe@gmail.com>
 <20200806204910.6fa489d7aabd5c8026f4c704@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10502
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 malwarescore=0 spamscore=0 clxscore=208 impostorscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=48
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210160144
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: clear links count in
 ocfs2_mknod() if an error occurs
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: MxA55WE8nifai5yWeOvsQ053N__ONEUX
X-Proofpoint-ORIG-GUID: MxA55WE8nifai5yWeOvsQ053N__ONEUX
Reporting-Meta:
 AAFR6iT6yYFpRbn4SPgxykCB4c/Ix0kodlUUPASEt+sTDO15K9KqH9pCIWpmJMBj
 K1j5RvPZrFkb+Vy6tPnrvObuarijILt+Jj9QFjQM00kdvDabBddeTJtJbUrUguu8
 qQqJ5Kx3TBbg5AYPK7uDsCbatkspaZkQsNz98Qv+bVQzQoDcwuM6Bz7gk8CT3f9+
 7lcYQB6m1JWLIjbmX8KV4UyFarOrBdZUAI1+cisMN2vlRtdIK6zn0SxG8pxsvCkA
 G6r1n0OBjeXkGOpQXU9iVjhS5vgRxKv0N8l/VdatO8kO6D72GlNCrpZpUZ1Uu/FR
 toX2lua7UnQVi1zwZ+ydZq5bznYNbfP7o+twBt6Fp5QjBFjKGb5OlshU/61CV+bu
 QYqfOvZ8aDbv4L4hoEz14u34IZuQqBJXlNZuN1LLnqz6VCrh92D1YBhWRrRswjk5
 dGTGfjYhH36x8RUIscMjy/vL6AKdXnaa9ZTbmlZMViFI07py6etMxRmE6maAoEuE
 1Y901dlcepbBt5tx5MCBw0FmYVR0KvzsDjaoMUtmDZts


I've been sitting on this patch series for over two years!  I assume
the problem isn't terribly serious.

Can we please come to a decision on how to proceed?  Thanks.

The current patches from the mm tree are below.

From: Wangyan <wangyan122@huawei.com>
Subject: ocfs2: clear links count in ocfs2_mknod() if an error occurs

In this condition, the inode can not be wiped when error happened.
ocfs2_mkdir()
  ->ocfs2_mknod()
    ->ocfs2_mknod_locked()
      ->__ocfs2_mknod_locked()
        ->ocfs2_set_links_count() // i_links_count is 2
    -> ... // an error accrue, goto roll_back or leave.
    ->ocfs2_commit_trans()
    ->iput(inode)
      ->evict()
        ->ocfs2_evict_inode()
          ->ocfs2_delete_inode()
            ->ocfs2_inode_lock()
              ->ocfs2_inode_lock_update()
                ->ocfs2_refresh_inode()
                  ->set_nlink();    // inode->i_nlink is 2 now.
            /* if wipe is 0, it will goto bail_unlock_inode */
            ->ocfs2_query_inode_wipe()
              ->if (inode->i_nlink) return; // wipe is 0.
            /* inode can not be wiped */
            ->ocfs2_wipe_inode()
So, we need clear links before the transaction committed.

Link: http://lkml.kernel.org/r/d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs
+++ a/fs/ocfs2/namei.c
@@ -454,8 +454,12 @@ roll_back:
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && new_fe_bh != NULL)
+			ocfs2_set_links_count((struct ocfs2_dinode *)
+					new_fe_bh->b_data, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -599,6 +603,8 @@ static int __ocfs2_mknod_locked(struct i
 leave:
 	if (status < 0) {
 		if (*new_fe_bh) {
+			if (fe)
+				ocfs2_set_links_count(fe, 0);
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
@@ -2028,8 +2034,12 @@ bail:
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && new_fe_bh != NULL)
+			ocfs2_set_links_count((struct ocfs2_dinode *)
+					new_fe_bh->b_data, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
_





From: Wangyan <wangyan122@huawei.com>
Subject: ocfs2: fix ocfs2 corrupt when iputting an inode

In this condition, it will cause an bug on error.
ocfs2_mkdir()
  ->ocfs2_mknod()
    ->ocfs2_mknod_locked()
      ->__ocfs2_mknod_locked()
        //Assume inode->i_generation is genN.
        ->inode->i_generation = osb->s_next_generation++;
        // The inode lockres has been initialized.
        ->ocfs2_populate_inode()
        ->ocfs2_create_new_inode_locks()
            ->An error happened, returned value is non-zero
      // free the start_bit x in bg_blkno
      ->ocfs2_free_suballoc_bits()
    ->...  /* Another process execute mkdir success in this place,
              and it occupied the start_bit x in bg_blkno
              which has been freed before. Its inode->i_generation
              is genN + 1 */
    ->iput(inode)
      ->evict()
        ->ocfs2_evict_inode()
          ->ocfs2_delete_inode()
            ->ocfs2_inode_lock()
              ->ocfs2_inode_lock_update()
                /* Bug on here, genN != genN + 1 */
                ->mlog_bug_on_msg(inode->i_generation !=
                  le32_to_cpu(fe->i_generation))

So, we need not to reclaim the inode when the inode->ip_inode_lockres
has been initialized. It will be freed in iput().

Link: http://lkml.kernel.org/r/ef080ca3-5d74-e276-17a1-d9e7c7e662c9@huawei.com
Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/namei.c~ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode
+++ a/fs/ocfs2/namei.c
@@ -641,7 +641,8 @@ static int ocfs2_mknod_locked(struct ocf
 	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
+	if (status < 0 && !(OCFS2_I(inode)->ip_inode_lockres.l_flags &
+				OCFS2_LOCK_INITIALIZED)) {
 		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
 		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
 				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
_


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

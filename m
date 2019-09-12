From: Gang He <GHe@suse.com>
Date: Thu, 12 Sep 2019 10:54:52 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: protect get_block with inode
 cluster lock
In-Reply-To: <HK0PR02MB378004F783D9D9B480923E0AD5B00@HK0PR02MB3780.apcprd02.prod.outlook.com>
References: <20190910173046.27360-1-junxiao.bi@oracle.com>
	<62c3b635-74f3-1670-4ebc-b22ac84c224d@linux.alibaba.com>
	<46a8b1b0-5f5b-daa6-ebce-471651b4d4d6@oracle.com>
	<CH2PR18MB3206599CCA4772442FC39B8FCFB00@CH2PR18MB3206.namprd18.prod.outlook.com>
	<HK0PR02MB378004F783D9D9B480923E0AD5B00@HK0PR02MB3780.apcprd02.prod.outlook.com>
Message-ID: <CH2PR18MB32063D6E8E1597C6DB5AA771CFB00@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi ChangWei,

Please see my comments inline.

> -----Original Message-----
> From: ocfs2-devel-bounces at oss.oracle.com
> [mailto:ocfs2-devel-bounces at oss.oracle.com] On Behalf Of Changwei Ge
> Sent: 2019?9?12? 18:26
> To: jiangqi903 at gmail.com; Changwei Ge <chge@linux.alibaba.com>; Junxiao
> Bi <junxiao.bi@oracle.com>; ocfs2-devel at oss.oracle.com; Gang He
> <GHe@suse.com>
> Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: protect get_block with inode cluster
> lock
> 
> Hi Gang,
> 
> IIUC, you worried that local node might use the old inode meta like 'inode
> size", right?
Inode block and extent blocks for a file.
My means, if there is not inode meta lock acquire, the inode meta-blocks changes from the other node cannot write-back to the disk immediately, since meta-data block write-back depends on lock downgrade hook.

> 
> If so, in ocfs2_direct_IO() which is the caller of
> ocfs2_lock_get_block() and ocfs2_dio_wr_get_block() is already using inode
> meta.
> 
> Should we also lock inode there?
> 
> I think the way how we guarantee what you mentioned is we acquire inode
> cluster lock with RW cluster lock held(in ocfs2_file_write_iter()), after which we
> a see a consistent inode.
My concerns are,
If the direct-io inode has been in the memory in the past (maybe this is second read for this node).
Then, before do the direct-io read, the caller cannot see the meta-data block changes, which were just made from the other nodes.
In this case, if we can hit the problem?

Thanks
Gang

> 
> 
> I suppose if other node wants to change inode extent tree(truncating,
> appending, punching hole), it should acquire first, by which during local node
> write operation, we can use a stable extent tree.
> 
> 
> Thank,
> 
> Changwei
> 
> 
> On 2019/9/12 5:34 ??, Gang He wrote:
> > Hi Guys,
> >
> > I went through the ocfs2 code today.
> > I think there should be a ocfs2_inode_lock() in the ocfs2_lock_get_block()
> function.
> > Why?
> > ocfs2_rw_lock is used to protect read/write operation from the
> > different nodes, but it cannot synchronize the inode meta-data changes, that
> means one node cannot on-time see the meta-data changes(e.g. extent blocks)
> from the other nodes.
> > The meta-data consistency should be guaranteed by ocfs2_inode_lock.
> > Anyway,
> > this ocfs2_inode_lock should be added here, but we should do a full testing
> after this patch, to make sure there is not any deadlock.
> > Second, according to my comments, I think the patch reporter should be
> able to give an example for why we need to add this patch.
> >
> > Thanks
> > Gang
> >
> >> -----Original Message-----
> >> From: ocfs2-devel-bounces at oss.oracle.com
> >> [mailto:ocfs2-devel-bounces at oss.oracle.com] On Behalf Of Junxiao Bi
> >> Sent: 2019?9?12? 1:40
> >> To: jiangqi903 at gmail.com; Changwei Ge <chge@linux.alibaba.com>;
> >> ocfs2-devel at oss.oracle.com
> >> Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: protect get_block with
> >> inode cluster lock
> >>
> >> Hi Joseph & Changwei,
> >>
> >> This is found by just reviewing source code, according the lock
> >> semantic, for accessing extent tree, alloc_sem and ip cluster lock should be
> acquired.
> >> ocfs2_dio_wr_get_block() had these two lock acquired. rw_lock can
> >> protect the tree from the write, but i am not sure whether there were
> >> other flow changing extent tree without rw lock held.
> >>
> >> Thanks,
> >>
> >> Junxiao.
> >>
> >> On 9/10/19 7:33 PM, Changwei Ge wrote:
> >>> Hi Junxiao,
> >>>
> >>>
> >>> As _RW_ cluster lock with EX level is held by local node, is that
> >>> possible other node has a chance to touch the extent tree belonging
> >>> to the same inode?
> >>>
> >>>
> >>> Thanks,
> >>>
> >>> Changwei
> >>>
> >>>
> >>> On 2019/9/11 1:30 ??, Junxiao Bi wrote:
> >>>> Inode cluster lock should be acquired to avoid extent tree changed
> >>>> by other cluster nodes.
> >>>>
> >>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> >>>> ---
> >>>>  ? fs/ocfs2/aops.c | 6 ++++++
> >>>>  ? 1 file changed, 6 insertions(+)
> >>>>
> >>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c index
> >>>> a4c905d6b575..5ae7253d04b0 100644
> >>>> --- a/fs/ocfs2/aops.c
> >>>> +++ b/fs/ocfs2/aops.c
> >>>> @@ -127,9 +127,15 @@ static int ocfs2_lock_get_block(struct inode
> >>>> *inode, sector_t iblock,
> >>>>  ????? int ret = 0;
> >>>>  ????? struct ocfs2_inode_info *oi = OCFS2_I(inode);
> >>>>  ? +??? ret = ocfs2_inode_lock(inode, NULL, 0);
> >>>> +??? if (ret) {
> >>>> +??????? mlog_errno(ret);
> >>>> +??????? return ret;
> >>>> +??? }
> >>>>  ????? down_read(&oi->ip_alloc_sem);
> >>>>  ????? ret = ocfs2_get_block(inode, iblock, bh_result, create);
> >>>>  ????? up_read(&oi->ip_alloc_sem);
> >>>> +??? ocfs2_inode_unlock(inode, 0);
> >>>>  ? ????? return ret;
> >>>>  ? }
> >> _______________________________________________
> >> Ocfs2-devel mailing list
> >> Ocfs2-devel at oss.oracle.com
> >> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 18 Jan 2010 21:06:38 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <4B5122D8.9030400@oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
Message-ID: <20100118130638.GA3549@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-15 18:22, Sunil Mushran wrote:
> Apart from this, you have to handle edge conditions. Like umount
> and mount. What if the freeze is issued just before a node is about
> to umount. Or, another node tries to mount the volume while it is
> frozen.

Yes. there is problem when umount the volume when it's frozen.

no problem a node tries mount the volume while it's frozen. it just
waits for the cluster to be thawed. --sure maybe timeout if the
volume is not thawed in time.
>
> Also, recovery. What if a node dies when a node is frozen. Think
> how you will handle that.
>
I don't think there is problem if a node dies when cluster is frozen.
if the dead node is the master node, the cluster is thawed. --this
should be a note/limitation to man page I think.
if it's a non-master node, it's just fine. dead node performs no update
on the volume.

so what's your concern?

>> +	sb = freeze_bdev(osb->sb->s_bdev);
>> +	if (IS_ERR(sb)) {
>> +		/* the error is returned by ocfs2_freeze_fs() */
>> +		err = PTR_ERR(sb);
>> +		if (err == -ENOTSUPP) {
>> +			/* we got freeze request but we don't support it */
>> +			BUG();
>> +		} else {
>> +			/* we don't issue cluster lock in ocfs2_freeze_fs() for
>> +			 * a freeze request(from other node). no other error
>> +			 * should be returned.
>> +			 */
>> +			BUG();
>> +		}
>> +	}
>>   
>
> Why not one BUG. This needs some more thought. See if
> we can gracefully handle these errors.
It's more readable. or alternative way is log the errno before BUG().
maybe my comment in the cases are not clear.

>
> BUG should be reserved to detect code errors. Or, really weird
> errors we don't expect. Like memory corruption. This is a simple
> error. We should try to handle this gracefully.
>
actually, freeze_bdev() it's doesn't return errors except the error
turned by freeze_fs().
if ocfs2_freeze_worker() is called, ocfs2_freeze_fs() returning
-ENOTSUPP is logic bug. and this case, we don't call cluster lock in
ocfs2_freeze_fs(), so no other error is returned. thus it's also logic
bug if other error is returned.
in other words, freeze_bdev() shouldn't return error here. so I think the two
BUG() is no problem.


>>  +static int is_kernel_thread()
>> +{
>> +	if (current->flags & PF_KTHREAD)
>> +		return 1;
>> +	return 0;
>> +}
>>   
>
> static inline
> return (current->flags & PF_KTHREAD);

Ok. though it's not called heavily.
>> +static int ocfs2_freeze_fs(struct super_block *sb)
>> +{
>> +	int ret = 0;
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>> +
>> +	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
>> +
>> +	if (!ocfs2_freeze_lock_supported(osb)) {
>> +		return -ENOTSUPP;
>> +	}
>> +
>> +	printk(KERN_INFO "ocfs2: Request to freeze block device (%s)\n",
>> +	       osb->dev_str);
>>   
>
> remove this printk

Ok.
>> +
>> +	/* cluster lock is issued only when this is the IOCTL process.(other
>> +	 * case ocfs2_freeze_fs() is called in ocfs2_wq thread)
>> +	 */
>> +
>> +	if (!is_kernel_thread()) {
>> +		/* this is ioctl thread, issues cluster lock */
>> +		ret = ocfs2_freeze_lock(osb, 1);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +		} else {
>> +			printk(KERN_INFO "ocfs2: Block device (%s) frozen by local\n",
>> +			       osb->dev_str);
>> +		}
>> +	} else {
>> +		/* this is ocfs2_wq kernel thread. we do freeze on behalf of
>> +		 * the requesting node, don't issue cluster lock again.
>> +		 */
>> +		printk(KERN_INFO "ocfs2: Block device (%s) frozen by remote\n",
>> +		       osb->dev_str);
>> +	}
>>   
>
> Make these KERN_NOTICEs.

Ok.
>> +static int ocfs2_unfreeze_fs(struct super_block *sb)
>> +{
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>> +
>> +	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
>> +
>> +	if (!ocfs2_freeze_lock_supported(osb))
>> +		return -ENOTSUPP;
>>   
>
> This check should move into the if below because then we can
> make it a BUG_ON for the remote case.
>
Ok.

>> +
>> +	if (!is_kernel_thread()) {
>> +		/* this is the ioctl user thread. */
>> +		if (!is_freeze_master(osb)) {
>> +			/* THAW ioctl on a node other than the one on with cluster
>> +			 * is frozen. don't thaw in the case. returns -EINVAL so
>> +			 * that osb->sb->s_bdev->bd_fsfreeze_count can be decreased.
>> +			 */
>> +
>> +			if (!osb->frozen_by_master) {
>> +				/* this is from a nested cross cluster thaw
>> +				 * case:
>> +				 * frozen from another node(node A)
>> +				 * frozen from this node(not suppored though)
>> +				 * thawed from node A
>> +				 * thawed from this node(coming here)
>> +				 *
>> +				 * thaw this node only.
>> +				 */
>>   
>
> If we don't support nested freeze, then why add this code.

Though we don't support it, we hope to make the operation succeed.
the big pain is the we have no way to know if a nested freeze is done
againt ocfs2 volume. the second freeze doesn't come to ocfs2, it returns
by vfs(in freeze_bdev()). so we can prevent user to do a nested freeze.

we can't return error. if we do, the thaw fails with volume still frozen
and no further operation can recover the state.

>
>> +				printk(KERN_INFO "ocfs2: Block device (%s) thawed"
>> +				       " by local\n", osb->dev_str);
>> +				goto bail;
>> +			}
>> +
>> +			/* now the cluster still frozen by another node,
>> +			 * fails this request
>> +			 */
>> +			printk(KERN_INFO "ocfs2: thawing %s on invalid node\n",
>> +			       osb->dev_str);
>> +			return -EINVAL;
>> +		}
>>   
>
> EINVAL is enough. No need for printks.
OK.

regards,
wengang.

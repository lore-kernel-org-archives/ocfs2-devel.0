From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 20 Jan 2010 12:55:31 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <4B565355.8050406@oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
Message-ID: <20100120045531.GA3794@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-19 16:50, Sunil Mushran wrote:
>> Yes. there is problem when umount the volume when it's frozen.
>
> Not just that. What if two nodes race. One umounts and one freezes.
> As umount is a series of steps, you will have to figure out upto
> where it is ok to participate in the freeze and where it is better
> to wait for the umount to complete.
>
> You will have to take deadlocks into account. e.g., umounting
> flushes the local alloc. If you to delay responding to the freeze,
> you may deadlock because the node that holds the global bitmap
> lock may have been frozen the fs by then.

Yes. needs more considerations.
>
>> no problem a node tries mount the volume while it's frozen. it just
>> waits for the cluster to be thawed. --sure maybe timeout if the
>> volume is not thawed in time.
>
> Again, think of the race conditions. Hint: You may want to take the
> superblock lock before taking the freeze lock.
>

seems we need a noqueue version of the ocfs2_freeze_lock(). timeout it
after some retries.

>> I don't think there is problem if a node dies when cluster is frozen.
>> if the dead node is the master node, the cluster is thawed. --this
>> should be a note/limitation to man page I think.
>> if it's a non-master node, it's just fine. dead node performs no update
>> on the volume.
>>
>> so what's your concern?
>
> By master you mean the node that does the freeze, right?
> If so, then yes.

yes.
> But of another node dies, we may have to thaw the node then too because
> we will have to replay the journal as part of recovery. Think about this.

Agree. ocfs2_sync_fs() ensures the finish of journal committing, but not ensures
the finish of checkpointing.
so it needs replay the journal if a node die.
>
>>>> +	sb = freeze_bdev(osb->sb->s_bdev);
>>>> +	if (IS_ERR(sb)) {
>>>> +		/* the error is returned by ocfs2_freeze_fs() */
>>>> +		err = PTR_ERR(sb);
>>>> +		if (err == -ENOTSUPP) {
>>>> +			/* we got freeze request but we don't support it */
>>>> +			BUG();
>>>> +		} else {
>>>> +			/* we don't issue cluster lock in ocfs2_freeze_fs() for
>>>> +			 * a freeze request(from other node). no other error
>>>> +			 * should be returned.
>>>> +			 */
>>>> +			BUG();
>>>> +		}
>>>> +	}
>>>>   
>>> Why not one BUG. This needs some more thought. See if
>>> we can gracefully handle these errors.
>> It's more readable. or alternative way is log the errno before BUG().
>> maybe my comment in the cases are not clear.
>
> First problem is that the comments are redundant. People reading the
> code know what ENOTSUPP means. Comment code that is not obvious to the
> reader.

Ok.
> Secondly, why BUG? As in, why not handle this more gracefully. I understand
> that this is a worker thread in a remote node that has no way of  
> returning an
> error.
>

Ok, I will consider how to do it gracefully.
> One solution is to fire off a timer in the node doing the freezing that
> does a cancel convert after say 30 secs. As in, if it is unable to get the
> EX in that time, abort the freeze.
>

that leads to the freeze operation last at lease 30 secs?

>> Though we don't support it, we hope to make the operation succeed.
>> the big pain is the we have no way to know if a nested freeze is done
>> againt ocfs2 volume. the second freeze doesn't come to ocfs2, it returns
>> by vfs(in freeze_bdev()). so we can prevent user to do a nested freeze.
>>
>> we can't return error. if we do, the thaw fails with volume still frozen
>> and no further operation can recover the state.
>>
>
> Taking the superblock lock will prevent this.
hope your detail for this.

regards,
wengang.

From: Changwei Ge <ge.changwei@h3c.com>
Date: Sat, 31 Mar 2018 02:06:32 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't evaluate buffer head to NULL
 managed by caller
References: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
	<9e21437e-0c16-4bc7-2e87-a8310b2172ea@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F2958D95@H3CMLB12-EX.srv.huawei-3com.com>
	<f08b4265-6c49-489f-6168-1ac966f96bbf@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F2958E1B@H3CMLB12-EX.srv.huawei-3com.com>
	<2be324cc-2a77-6b17-3441-1f17d6e24b24@gmail.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F295A6C8@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2018/3/30 10:38, Joseph Qi wrote:
> 
> 
> On 18/3/30 10:17, Changwei Ge wrote:
>>>>> Since we assume caller has to pass either all NULL or all non-NULL,
>>>>> here we will only put bh internal allocated. Am I missing something?
>>>> Thanks for your review.
>>>> Yes, we will only put bh internally allocated.
>>>> If bh is reserved in advance, we will not put it and re-assign it to NULL.
>>>>
>>> So this branch won't have risk, right?
>> Sorry... I'm not sure if I understand you correctly.
>> This branch will be walked through when previous part of bhs[] faces a read
>> failure in order to put bh allocated in ocfs2_read_blocks().
>> And we assume all bh should be NULL or non-NULL, if new_bh is set, the back part
>> should also be put to release those buffer heads.
>>
>> If I made a mistake or misunderstand you, please let me know.
> 
> 
> I'm saying that sb_getblk() will only be called if bh hasn't been
> allocated yet. That means if it fails, the bh to be put can be
> guaranteed internal allocated.

If sb_getblk() fails, code will bail out rather than goes into this branch 
check. Particularly speaking, the *second* for loop will be jumped.
And I do think we need to check new_bh here to put the rest of buffer heads if 
one buffer head encounters read failure. If below code snippet is walked in, the 
mentioned code branch can work.
			
			if (!buffer_uptodate(bh)) {
				/* Status won't be cleared from here on out,
				 * so we can safely record this and loop back
				 * to cleanup the other buffers. Don't need to
				 * remove the clustered uptodate information
				 * for this bh as it's not marked locally
				 * uptodate. */
				status = -EIO;
				put_bh(bh);
				bhs[i] = NULL;
				continue;
			}

After our discussion I find another problem residing in ocfs2_read_blocks() too.
I will send a patch set to fix them all later.

> Also I don't think the WARN check is necessary as this is common path
> and will bring additional cpu consumption. We can make it clear at
> comments of ocfs2_read_blocks() that either all NULL or non-NULL bhs
> is prerequisite for the caller. And then we make sure we won't put bh
> that is allocated outside.

Agree.

Thanks,
Changwei

> 
> Thanks,
> Joseph
> 

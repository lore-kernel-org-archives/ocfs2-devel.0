From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 30 Mar 2018 10:37:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't evaluate buffer head to NULL
 managed by caller
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2958E1B@H3CMLB12-EX.srv.huawei-3com.com>
References: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
	<9e21437e-0c16-4bc7-2e87-a8310b2172ea@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F2958D95@H3CMLB12-EX.srv.huawei-3com.com>
	<f08b4265-6c49-489f-6168-1ac966f96bbf@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F2958E1B@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <2be324cc-2a77-6b17-3441-1f17d6e24b24@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/3/30 10:17, Changwei Ge wrote:
>>>> Since we assume caller has to pass either all NULL or all non-NULL,
>>>> here we will only put bh internal allocated. Am I missing something?
>>> Thanks for your review.
>>> Yes, we will only put bh internally allocated.
>>> If bh is reserved in advance, we will not put it and re-assign it to NULL.
>>>
>> So this branch won't have risk, right?
> Sorry... I'm not sure if I understand you correctly.
> This branch will be walked through when previous part of bhs[] faces a read 
> failure in order to put bh allocated in ocfs2_read_blocks().
> And we assume all bh should be NULL or non-NULL, if new_bh is set, the back part 
> should also be put to release those buffer heads.
> 
> If I made a mistake or misunderstand you, please let me know.


I'm saying that sb_getblk() will only be called if bh hasn't been
allocated yet. That means if it fails, the bh to be put can be
guaranteed internal allocated.
Also I don't think the WARN check is necessary as this is common path
and will bring additional cpu consumption. We can make it clear at
comments of ocfs2_read_blocks() that either all NULL or non-NULL bhs
is prerequisite for the caller. And then we make sure we won't put bh
that is allocated outside.

Thanks,
Joseph

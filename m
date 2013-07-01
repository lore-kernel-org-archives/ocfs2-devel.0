From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 1 Jul 2013 11:44:26 -0500
Subject: [Ocfs2-devel] [PATCH] unlink performance: wait for open lock in
 case of dirs
In-Reply-To: <51CFD3BC.70108@oracle.com>
References: <20130615020510.GA4487@shrek.cartoons>
	<20130628161209.95b024c90df90188a8367c8f@linux-foundation.org>
	<51CFD3BC.70108@oracle.com>
Message-ID: <CAJtY7HXQHsKJT1JvTdx5__3XMuWPvSuwAWYg44PquHrkg03DNA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jun 30, 2013 at 1:44 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 06/29/2013 07:12 AM, Andrew Morton wrote:
>
>> On Fri, 14 Jun 2013 21:05:10 -0500 Goldwyn Rodrigues <rgoldwyn@gmail.com> wrote:
>>
>>> This patch is to improve the unlink performance. Here is the scenario:
>>>
>>> On node A, create multiple directories say d1-d8, and each have 3
>>> files under it f1, f2 and f3.
>>> On node B, delete all directories using rm -Rf d*
>>>
>>> The FS first unlinks f1, f2 and f3. However, when it performs
>>> ocfs2_evict_inode() -> ocfs2_delete_inode() ->
>>> ocfs2_query_inode_wipe() -> ocfs2_try_open_lock() on d1, it fails
>>> with -EAGAIN. The open lock fails because on the remote node
>>> a PR->EX convert takes longer than a simple EX grant.
>>>
>>> This starts a checkpoint because OCFS2_INODE_DELETED flag is not set
>>> on the directory inode. Now, a checkpoint interferes with the journaling
>>> of the inodes deleted in the following unlinks, in our case,
>>> directories d2-d8 and the files contained in it.
>>>
>>> With this patch, We wait on a directory EX lock only if we already
>>> have an open_lock in PR mode. This way we will avoid the ABBA locking.
>>>
>>> By waiting for the open_lock on the directory, I am getting a unlink
>>> performance improvement of a rm -Rf of 50-60% in the usual case.
>>>
>>> Also, folded ocfs2_open_lock and ocfs2_try_open_lock into one.
>>>
>>> Let me know if you would like to see the test case.
>>
>> We need some more review and test of this patch, please.
>>
>> The patch doesn't apply to current kernels - please redo, retest and
>> resend it.

Yes, I sent it against an older kernel. I will update it once I
incorporate the other review comments. Thanks for this comment.

>>
>> In particular, the kernel you're patching doesn't have the
>> ocfs2_is_hard_readonly() tests in ocfs2_open_lock() and
>> ocfs2_try_open_lock().
>>
>> And looking at those tests, I wonder about ocfs2_open_lock().
>>
>> : int ocfs2_open_lock(struct inode *inode)
>> : {
>> :     int status = 0;
>> :     struct ocfs2_lock_res *lockres;
>> :     struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> :
>> :     BUG_ON(!inode);
>> :
>> :     mlog(0, "inode %llu take PRMODE open lock\n",
>> :          (unsigned long long)OCFS2_I(inode)->ip_blkno);
>> :
>> :     if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
>> :             goto out;
>> :
>> :     lockres = &OCFS2_I(inode)->ip_open_lockres;
>> :
>> :     status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
>> :                                 DLM_LOCK_PR, 0, 0);
>> :     if (status < 0)
>> :             mlog_errno(status);
>> :
>> : out:
>> :     return status;
>> : }
>>
>> It will return zero if ocfs2_is_hard_readonly().  Is that correct?
>
>> Should it return -EROFS for writes?

Yes, it should.


>
> Hi Andrew,
>
> That is correct for the current design, because ocfs2_open_lock() is
> implemented to grant a lock in protect read mode.
>
> The ocfs2_is_hard_readonly() has been introduced to ocfs2_open_lock()
> by commit: 03efed8a2a1b8e00164eb4720a82a7dd5e368a8e
>
>     ocfs2: Bugfix for hard readonly mount
>         ocfs2 cannot currently mount a device that is readonly at the media
>     ("hard readonly").  Fix the broken places.
>     see detail: http://oss.oracle.com/bugzilla/show_bug.cgi?id=1322
>
>> After your patch, this code does
>> know whether the attempt was for a write.
>
>
>
> Yes, with this change, it need a fix indeed.
>
>>
>> Please check all that.
>
>
>
>
> Hi Goldwyn,
>
> Sorry for the too late response as I have mentioned that I'll take a look at it,
> but some internal tasks really racked my brains in the past couple of weeks.

No problem.

>
> Just as Andrew's comments, this patch can not be applied properly against the
> upstream development tree, could you please re-base it.

Yes, will do. I have other comments from Mark as well.

>
> If we merge ocfs2_open_lock()/ocfs2_open_try_lock() into one, looks the semantics of
> ocfs2_open_lock() is broke with the 'write' option is introduced, but this is not a
> big issue as we can tweak up the comments as well as those functions which would be
> affected, but we need to run ocfs2-test(at least cover all the code path which are
> involved in this change) to avoid any regression, it can be download from:
> https://oss.oracle.com/projects/ocfs2-test/source.html
> https://oss.oracle.com/osswiki/OCFS2/Ocfs2TestList.html
>
> Another thing come to mind since this patch would affect ocfs2_evict_inode() with
> ocfs2_try_open_lock(), i.e, the following call chains:
>
> ocfs2_evict_inode()
> |
> |-------ocfs2_delete_inode()
>         |
>         |-------ocfs2_query_inode_wipe()
>         |       |
>         |       |-------ocfs2_try_open_lock()
>         |       |
>         |-------ocfs2_clear_inode()
>                 |
>                 |---------ocfs2_open_unlock()
>
> OCFS2 has a DEAD LOCK issue when creating/removing tons of files in parallel if the
> disk quota is enabled, please refer to:
> https://oss.oracle.com/bugzilla/show_bug.cgi?id=1339
>
> As per the old discussions, Jan Kara pointed out that there is a race in
> ocfs2_evict_inode() if consider the following lock sequences:
>
> ocfs2_evict_inode()
> |
> |-------ocfs2_inode_lock()
>         |
>         |-------ocfs2_try_open_lock() [ try to get open lock in EX mode ]
>                 |
>                 |-------ocfs2_inode_unlock()
>                         |
>                         |-------ocfs2_open_unlock() [ drops shared open lock that is hold ]
>
> Quotas from Jan:
> """
> Now if two nodes happen to execute ocfs2_evict_inode() in parallel and
> ocfs2_try_open_lock() happens on both nodes before ocfs2_open_unlock() is
> called on any of them, ocfs2_try_open_lock() fails for both nodes...
>
> I would think that the code should be reorganized so that shared open
> lock is dropped before we drop inode lock. Then the race could not happen.
> But I'm not sure if something else would not break.
> """

I could not find the reference of this in the bug. Is it discussed on
the ML. Do you have a link so I can look at the history?

>
> This is deserve to give a try IMHO, especially there would be kind of dependencies
> with your fix, and that would be wonderful if we can have your improvement as well
> as lock sequences adjustments that might fix the quota problems.
>

Yes, I understand. Please provide the references if possible so I get
the bigger picture.


--
Goldwyn

From: Joseph Qi <joseph.qi@huawei.com>
Date: Sun, 2 Jun 2013 09:32:04 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: should not use le32_add_cpu to
 set ocfs2_dinode i_flags
In-Reply-To: <51AA065A.4040400@oracle.com>
References: <51A6DA6A.5060301@huawei.com>
	<20130531152535.a832b5dd6435595798ffb73d@linux-foundation.org>
	<51AA065A.4040400@oracle.com>
Message-ID: <51AAA094.9050508@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff & Andrew,
We found this bug when we do analysis for a read-only filesystem bug
that is directly caused by dinode flags mismatch.
Of course Jeff you could fix the comments and make it comprehensible.

On 2013/6/1 22:34, Jeff Liu wrote:
> Hi Andrew,
> 
> Sorry for the late response because I just returned from the LinuxCon/Japan.
> 
> I'm afraid that Joesph can not follow this thread up in time since today is the
> weekend in China.  So please let me answer your question on behalf of Joesph
> as a quick response.
> 
> On 06/01/2013 06:25 AM, Andrew Morton wrote:
> 
>> On Thu, 30 May 2013 12:49:46 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
>>
>>> If we use le32_add_cpu to set ocfs2_dinode i_flags, it may lead to the
>>> corresponding flag corrupted. So we should change it to bitwise and/or
>>> operation.
>>>
>>
>> The usual question: what is the end-user impact of the bug which was
>> just fixed?
> 
> This patch can be treated as a trivial fix.  Yes, i_flags is operated in
> bitwise context, but those assignments are only happened at the time of
> initializing the corresponding OCFS2 private on-disk inode info.  Hence
> there is no impact from the end-user's perspective.
> 
> However, it's better to replace those three assignments with bitwise operations
> since they essentially should be.  In this way, we can immediately know that the
> business performed on i_flags are in bitwise rather than increasing or decreasing
> a count value. 
> 
>> For the usual reason: so I and others can decide which kernel versions
>> need the fix.
> 
> The current fix comments looks too horrible than it would be.
> Can it make your life easier if I repost this patch with the revised
> descriptions if Joseph agrees to me?
> 
> 
> Thanks,
> -Jeff
> 
> .
> 

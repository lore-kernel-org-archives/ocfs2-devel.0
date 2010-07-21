From: Jiaju Zhang <jjzhang.linux@gmail.com>
Date: Wed, 21 Jul 2010 22:20:22 +0800
Subject: [Ocfs2-devel] [PATCH] Fix the nested PR lock calling issue
In-Reply-To: <20100721092143.GA3100@laptop.jp.oracle.com>
References: <20100721082800.GA23840@linux-jjzhang>
	<20100721092143.GA3100@laptop.jp.oracle.com>
Message-ID: <AANLkTinhr_N4AtTX0ELD7JpDB0p-CyjUIkO7O4AW1PUp@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,

On Wed, Jul 21, 2010 at 5:21 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> Hi Jiaju,
>
> On 10-07-21 16:28, Jiaju Zhang wrote:
>> Hi,
>>
>> This is an attempt to fix the bug
>> https://bugzilla.novell.com/show_bug.cgi?id=614332
>> (also http://oss.oracle.com/bugzilla/show_bug.cgi?id=1278)
>>
>> The full log is available at comment #54 of bug 614332 at Novell
>> bugzilla. Simply speaking, it should be nested PR lock calling issue.
>> The calling sequence should be:
>>
>> node1 ? ? ? node2
>>
>> ? ? ? ? ? ? gr PR
>> ? ? ? ? ? ? ? |
>> ? ? ? ? ? ? ? V
>> PR(EX) -> BAST: OCFS2_LOCK_BLOCKED
>> ? ? ? ? ? ? ? |
>> ? ? ? ? ? ? ? V
>> ? ? ? ? ? ? rq PR
>> ? ? ? ? ? ? ? |
>> ? ? ? ? ? ? ? V
>> ? ? ? ? ? ? wait = 1
>>
>> Since we have already had the granted PR lock from the beginning, we
>> may not need to request the PR lock again.
>
> What's the real calling path?
> I guess you meant
> ocfs2_permission()(lock gothere)
> ?->ocfs2_check_acl()
> ?->ocfs2_get_acl()(require the lock again)
>
> But there is other ocfs2_get_acl() calling paths in which the lock is
> not taken before calling ocfs2_get_acl(). such as
> ocfs2_setattr()(the lock is taken and released before calling ocfs2_acl_chmod())
> ?->ocfs2_acl_chmod()
> ?->ocfs2_get_acl().
>
> So I think the patch is not safe.

Many thanks for pointing this out;)
I'll send an improved patch soon.

Thanks,
Jiaju

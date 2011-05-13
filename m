From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 13 May 2011 15:11:11 -0500
Subject: [Ocfs2-devel] ocfs2 crashes on xfstest 013
In-Reply-To: <4DCD640D.4060408@oracle.com>
References: <BANLkTi=VjeRc_6t-4vmCxpvwRAxCYjB_KA@mail.gmail.com>
	<4DCBD469.3090201@oracle.com>
	<BANLkTimwERrLio8N6d-JrR9KJgQgv3NQCw@mail.gmail.com>
	<4DCD640D.4060408@oracle.com>
Message-ID: <BANLkTikRdsPs00jKP4uFEOmArzcyqn8PKQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Fri, May 13, 2011 at 12:02 PM, Sunil Mushran
<sunil.mushran@oracle.com> wrote:
>> On Thu, May 12, 2011 at 7:36 AM, Tristan Ye<tristan.ye@oracle.com> ?wrote:
>>>
>>> Hi Goldwyn,
>>> ? ? ? ?The root cause was due to we didn't skip an existing hole
>>> somewhere when
>>> punching a hole, to speak more accurately, the bug occurs at the time
>>> when we
>>> removing a partial extent record(which also means the last extent record
>>> to
>>> remove), as a result, the hole-punching code attempts to remove more than
>>> the
>>> length of whole extent record, which leads to the failure of following
>>> assert(fs/ocfs2/alloc.c):
>>>
>>> 5507 ? ? ? ? BUG_ON(cpos< ?le32_to_cpu(rec->e_cpos) || trunc_range>
>>> ?rec_range);
>>>
>>> ? ? ? ?Could you please make a verification against my coming patch, I
>>> passed xfs's
>>> 013 testcase with the patch;-)
>>>
>> Did you post this patch? ... or am I being impatient?
>>
> Yes, he posted it.
>
> http://oss.oracle.com/pipermail/ocfs2-devel/2011-May/008077.html
>

Somehow, it did not reach my mailbox.
The patch works for me. Thanks for patching up.

Regards,
-- 
Goldwyn

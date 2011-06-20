From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 20 Jun 2011 12:34:22 -0500
Subject: [Ocfs2-devel] How can ecc be corrected?
In-Reply-To: <4DFF73DC.3010008@oracle.com>
References: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>
	<4DFB8694.6080303@oracle.com>
	<BANLkTi=Ar_iixpHfu+O53optr37=oj2q+Q@mail.gmail.com>
	<4DFBA79C.8060405@oracle.com>
	<20110617231621.GA16287@noexit.corp.google.com>
	<4DFF73DC.3010008@oracle.com>
Message-ID: <BANLkTimFvmrLQyjcD8jS4P_xM4UE4irNgQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 20, 2011 at 11:22 AM, Sunil Mushran
<sunil.mushran@oracle.com> wrote:
> On 06/17/2011 04:16 PM, Joel Becker wrote:
>>
>> On Fri, Jun 17, 2011 at 12:14:36PM -0700, Sunil Mushran wrote:
>>>>>
>>>>> If you have ideas, do share.
>>>>
>>>> No ideas as such. I raised this question because a customer was facing
>>>> this issue with the superblock and no way to fix it. Fortunately, he
>>>> can still use the filesystem. It is debugfs.ocfs2 which is failing. I
>>>> guess I will have to work on a patch to fix this.
>>>
>>> So I remember we had a bug in tunefs that changed the superblock
>>> without recomputing the checksum. It has been fixed since.
>>>
>>> How can he still use the fs?
>>>
>>> One solution is to disable it... manually. And then re-enable it using
>>> the latest tunefs.
>>
>> ? ? ? ?I thought we were going to patch fsck.ocfs2 to run in an
>> ignore-metaecc mode?
>
>
> Oh I did not know we had decided on that. Though that appears to be the
> best solution. fsck and debugfs always run in ignore-metaecc mode. fsck
> will need a fixup code for that.
>

Cool. I have sent a set of 3 patches on the tools mailing list. Let me
know if it works for you.

-- 
Goldwyn

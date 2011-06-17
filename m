From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Jun 2011 12:14:36 -0700
Subject: [Ocfs2-devel] How can ecc be corrected?
In-Reply-To: <BANLkTi=Ar_iixpHfu+O53optr37=oj2q+Q@mail.gmail.com>
References: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>	<4DFB8694.6080303@oracle.com>
	<BANLkTi=Ar_iixpHfu+O53optr37=oj2q+Q@mail.gmail.com>
Message-ID: <4DFBA79C.8060405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/17/2011 11:50 AM, Goldwyn Rodrigues wrote:
> On Fri, Jun 17, 2011 at 11:53 AM, Sunil Mushran
> <sunil.mushran@oracle.com>  wrote:
>> On 06/17/2011 08:55 AM, Goldwyn Rodrigues wrote:
>>> I am not able to understand the use of metaecc or the ECC in the
>>> metadata. All the metadata contain the ecc to check if the data
>>> written to the block is sane, but what happens in case the ecc does
>>> not match? All it does is fail in case it does not match. There does
>>> not seem a way to correct it.
>>>
>>> fsck simply fails in ocfs2_read_inode, (or in some cases such as
>>> superblock inode (2) does not even check) if the ecc does not match.
>>> What is the best way to correct ecc errors? I understand that an
>>> incorrect ECC means the data might be corrupt, but what if we want to
>>> recover? or is it not meant to be corrected at all?
>> I think originally our thought was that bad checksum means bad block. But
>> we are wiser now. As in, while that works in the fs, we could to do better
>> job in the tools. And that's the reason it is not yet enabled by default.
>>
> So, what is the plan in the future? Do you intend to put it as a
> default option or let things be as is?
>
> In any case, I agree we should modify tools to correct the filesystem
> (fsck) if the filesystem fails due to metaecc error or else we could
> end up having an unusable filesystem. It sure is a good debugging tool
> for development purposes though.

Oh absolutely it will be made a default. But we have to address this
shortcoming first.

>> If you have ideas, do share.
> No ideas as such. I raised this question because a customer was facing
> this issue with the superblock and no way to fix it. Fortunately, he
> can still use the filesystem. It is debugfs.ocfs2 which is failing. I
> guess I will have to work on a patch to fix this.

So I remember we had a bug in tunefs that changed the superblock
without recomputing the checksum. It has been fixed since.

How can he still use the fs?

One solution is to disable it... manually. And then re-enable it using
the latest tunefs.

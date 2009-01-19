From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sun, 18 Jan 2009 20:57:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
	ocfs2_statfs(), v4
In-Reply-To: <4973E2E3.2030106@suse.de>
References: <49704641.1010005@suse.de>
	<D9BD94CC-31A4-446D-A331-12CA8A5BD46D@oracle.com>
	<4973E2E3.2030106@suse.de>
Message-ID: <9E89783A-53C8-4999-9DD2-57237A03E1A2@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yeah... I was wrong. This should work.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


On Jan 18, 2009, at 6:18 PM, Coly Li <coly.li@suse.de> wrote:

>
>
> Sunil Mushran Wrote:
>> f_fsid.val[1] look wrong. Just set it to zero.
>>
> It's OK to set it to zero. But can you please to explain a little  
> bit why f_fsid.val[1] is wrong ?
> I tested the code and the f_fsid.val looked well.
>
> Thanks for the review.
>
>> On Jan 16, 2009, at 12:33 AM, Coly Li <coly.li@suse.de> wrote:
>>
>>> Currently f_fsid of struct kstatfs returned from ocfs2_statfs() is
>>> undefined (vfs layer fills 0 as
>>> default). Since in some conditions, f_fsid value might be used as
>>> (f_fsid, ino) pair to
>>> uniquely identify a file, ocfs2 should return a unique defined  
>>> f_fsid
>>> value from ocfs2_statfs().
>>>
>>> Because uuid_str is identified no mater on big or litlle endian
>>> machine, it's also endian consistent
>>> to use osb->uuid_str to generate f_fsid value.
>>>
>>> Signed-off-by: Coly Li <coly.li@suse.de>
>>> Cc: Sunil Mushran <sunil.mushran@oracle.com>
>>> Cc: Mark Fasheh <mfasheh@suse.com>
>>> ---
>>> fs/ocfs2/super.c |    4 ++++
>>> 1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index 43ed113..c953933 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -1425,6 +1425,10 @@ static int ocfs2_statfs(struct dentry  
>>> *dentry,
>>> struct kstatfs *buf)
>>>   buf->f_bavail = buf->f_bfree;
>>>   buf->f_files = numbits;
>>>   buf->f_ffree = freebits;
>>> +    buf->f_fsid.val[0] = crc32_le(0, osb->uuid_str,  
>>> OCFS2_VOL_UUID_LEN)
>>> +                & 0xFFFFFFFFUL;
>>> +    buf->f_fsid.val[1] = crc32_le(0, osb->uuid_str +  
>>> OCFS2_VOL_UUID_LEN,
>>> +                OCFS2_VOL_UUID_LEN) & 0xFFFFFFFFUL;
>>>
>>>   brelse(bh);
>>>
>>> -- 
>>> Coly Li
>>> SuSE Labs
>>>
>>>
>>>
>
> -- 
> Coly Li
> SuSE Labs

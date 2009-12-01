From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 01 Dec 2009 09:56:54 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Need to initialize uuid when
 setuping the osb.
In-Reply-To: <4B146C9D.5050305@oracle.com>
References: <1259309660-7732-1-git-send-email-tristan.ye@oracle.com>	<4B144223.8060804@oracle.com>
	<4B146C9D.5050305@oracle.com>
Message-ID: <4B1477E6.9020202@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi tristan,

Tristan wrote:
> Sunil Mushran wrote:
>> Tristan Ye wrote:
>>> I accidently found this when adding new ioctls for ocfs2
>>> to request fs info from none-prvileged users.
>>>
>>> ocfs2_super osb has successfully setuped osb.uuid_str, but
>>> it did leave the osb.uuid field NULL without proper initializing
>>> and bytes filling, it should be corrected I guess.
>>>
>>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>> ---
>>> fs/ocfs2/super.c | 7 +++++++
>>> 1 files changed, 7 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index c0e48ae..f15fea7 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -1920,6 +1920,12 @@ static int ocfs2_setup_osb_uuid(struct 
>>> ocfs2_super *osb, const unsigned char *uu
>>>
>>> BUG_ON(uuid_bytes != OCFS2_VOL_UUID_LEN);
>>>
>>> + osb->uuid = kzalloc(OCFS2_VOL_UUID_LEN, GFP_KERNEL);
>>> + if (osb->uuid == NULL)
>>> + return -ENOMEM;
>>> +
>>> + memmove(osb->uuid, uuid, OCFS2_VOL_UUID_LEN);
>> memmove() is an overkill when we know the areas do not overlap.
>> Use memcpy().
>>
>>> +
>>> osb->uuid_str = kzalloc(OCFS2_VOL_UUID_LEN * 2 + 1, GFP_KERNEL);
>>> if (osb->uuid_str == NULL)
>>> return -ENOMEM;
>>> @@ -2415,6 +2421,7 @@ static void ocfs2_delete_osb(struct ocfs2_super 
>>> *osb)
>>> kfree(osb->journal);
>>> if (osb->local_alloc_copy)
>>> kfree(osb->local_alloc_copy);
>>> + kfree(osb->uuid);
>>> kfree(osb->uuid_str);
>>> ocfs2_put_dlm_debug(osb->osb_dlm_debug);
>>> memset(osb, 0, sizeof(struct ocfs2_super));
>>
>> So we only use the string representation of the uuid. So I see no
>> use of this. Maybe we should just remove osb->uuid.
> 
> uuid field only takes up 16 bytes, while uuid_str needs 32 bytes...
> 
> why not just remove uuid_str instead?
There are many functions which use uuid_str.
One good example is debug_create_dir(It is a debugfs function, so we'd 
better not change it). This function needs a char * for the name of the 
created dir. So uuid is no use here and we have to convert uuid to uuid_str.

So I agree with Sunil that we can remove uuid if there is no user for it.

Regards,
Tao

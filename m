From: Coly Li <coly.li@suse.de>
Date: Fri, 16 Jan 2009 17:23:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
	ocfs2_statfs()
In-Reply-To: <496FB967.6030708@oracle.com>
References: <496F8957.3000201@suse.de> <496F8DBB.7080706@oracle.com>
	<496F931A.2040401@suse.de> <496F95A8.3030404@oracle.com>
	<20090115222120.GB17410@wotan.suse.de>
	<496FB967.6030708@oracle.com>
Message-ID: <49705201.8010101@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> Mark Fasheh wrote:
>> Well, mkfs.ocfs2/tunefs.ocfs2 is supposed to populate it s_uuid_hash
>> based
>> on the *original* uuid of the file system. We don't dynamically
>> calculate it
>> because uuid might change due to a clone operation, which would then
>> break
>> the hashing of that particular file system.
> 
> OK. I missed that bit.
> 
>> Since s_uuid_hash is feature specific, I think perhaps we should just use
>> some part of the uuid, which is always populated. For this, I think we
>> could
>> do the same as the o2cb dlm key (which has to also be pretty unique) -
>> crc32_le(uuid)
> 
> I was thinking the same.

Now I use crc32_le(osb->uuid_str) to generate fsid value. osb->uuid_str is string representation of
s_uuid. Since uuid_str is byte-by-byte, the f_fsid value should be endian consistent.

Would you please to review the v4 patch once more ?

Thanks for your comments.
-- 
Coly Li
SuSE Labs

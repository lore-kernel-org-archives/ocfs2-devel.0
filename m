From: Coly Li <coly.li@suse.de>
Date: Fri, 16 Jan 2009 17:19:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
	ocfs2_statfs()
In-Reply-To: <496F95A8.3030404@oracle.com>
References: <496F8957.3000201@suse.de> <496F8DBB.7080706@oracle.com>
	<496F931A.2040401@suse.de> <496F95A8.3030404@oracle.com>
Message-ID: <4970512F.6040009@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> It's worse. As far as I can see, the s_uuid_hash is never populated.
> So we have two problems. The second issue is urgent as we are
> using it in xattr.
> 
Thanks for pointing out this :)
I have updated the patch and sent out as v4.

> Coly Li wrote:
>> Sunil Mushran Wrote:
>>  
>>> Wondering whether this id needs to be endian consistent.
>>> For failover nfs setups maybe.
>>>     
>>
>> IMHO, It is. Because osb->uuid_hash is fetched by:
>>         osb->uuid_hash = le32_to_cpu(di->id2.i_super.s_uuid_hash);
>> CMIIW, It should work in nfs failover.
>>
>>  
[snip]
-- 
Coly Li
SuSE Labs

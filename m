From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 25 Feb 2009 11:46:36 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <49A4AEA1.1050607@oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
	<49A4AEA1.1050607@oracle.com>
Message-ID: <49A4BF1C.7020505@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

good point! thanks!

regards,
wengang.


>> +    alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
>> +    BUG_ON((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
> here, we shouldn't BUG_ON. It actually isn't a kernel bug. the 'bit' is 
> got from the disk by function ocfs2_get_suballoc_slot_bit. So maybe a 
> corrupt inode, maybe something else, but never a bug of ocfs2. ;) So 
> just return error please.
> 

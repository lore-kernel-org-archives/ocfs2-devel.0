From: Tiger Yang <tiger.yang@oracle.com>
Date: Tue, 29 Jul 2008 13:49:52 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2-tools: Add extended attribute
 support in mkfs.ocfs2
In-Reply-To: <20080725093315.GF6317@ca-server1.us.oracle.com>
References: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
	<20080725093315.GF6317@ca-server1.us.oracle.com>
Message-ID: <488EAF80.1070207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:

>> +struct ocfs2_xattr_entry {
>> +	__le32	xe_name_hash;
>> +	__le16	xe_name_offset;
>> +	__u8	xe_name_len;
>> +	__u8	xe_type : 7;
>> +	__u8	xe_local : 1;
>> +	__le64	xe_value_size;
>> +};
> 
> 	We removed the bitfields.

Do we really remove the bitfields? We have no space for new u8 in 
xattr_entry.
Mark said we just need change the bottom bit for xe_local.

> 
> 	This got shuffled around for a 64bit checksum field.  Etc.  Can
> you sync up with Tao?
> 
sure. I will sync up those data struct with Tao.

Thanks,
tiger

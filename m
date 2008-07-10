From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 10 Jul 2008 12:50:09 +0800
Subject: [Ocfs2-devel] [PATCH 05/15] Add xattr header in ocfs2.v2
In-Reply-To: <20080709225923.GA22129@eris>
References: <48648B3E.6050808@oracle.com>
	<20080627070110.GA20347@tma-pc2.cn.oracle.com>
	<20080709225923.GA22129@eris>
Message-ID: <48759501.5040006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> [ everything up until this patch looks great ]
> 
> On Fri, Jun 27, 2008 at 03:01:10PM +0800, Tao Ma wrote:
>> +struct ocfs2_xattr_entry {
>> +	__le32	xe_name_hash;
>> +	__le16	xe_name_offset;
>> +	__u8	xe_name_len;
>> +	__u8	xe_type : 7;
>> +	__u8	xe_local : 1;
> 
> Would you mind turning xe_type / xe_local into just one __u8 with the
> bottom-most bit reserved for the local bit and the upper 7 bits used as
> type? I'm not quite sure about whether bitfields are considered safe for use
> in disk structures. At the very least, it seems a bit controversial.
> 
> I would heartily support you creating two pairs of _set / _get macros in
> this file to aid in such a change.
Ok, I will modify it and I will also modify the design doc for it.
Thanks.

Regards,
Tao

From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 13 Jun 2008 09:54:46 +0800
Subject: [Ocfs2-devel] [PATCH 5/8] Add xattr header in ocfs2.v1
In-Reply-To: <20080612212117.GQ28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>
	<20080605073342.GA19789@tma-pc2.cn.oracle.com>
	<20080612212117.GQ28100@wotan.suse.de>
Message-ID: <4851D366.9060008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Thu, Jun 05, 2008 at 03:33:42PM +0800, Tao Ma wrote:
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>> ---
>>  fs/ocfs2/xattr.h |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 95 insertions(+), 0 deletions(-)
>>  create mode 100644 fs/ocfs2/xattr.h
>>
>> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
>> new file mode 100644
>> index 0000000..a5b93cf
> 
> Can we put this in ocfs2_fs.h instead? That way we still have just one place
> to look for describing the disk format.
ext3 separate its ext header in xattr.h, so we do like it does. But you 
may be right since we put all the stuffs concerning disk format in 
ocfs2_fs.h. I will modify it.
> 
> 
>> --- /dev/null
>> +++ b/fs/ocfs2/xattr.h
>> @@ -0,0 +1,95 @@
>> +/* -*- mode: c; c-basic-offset: 8; -*-
>> + * vim: noexpandtab sw=8 ts=8 sts=0:
>> + *
>> + * xattr.h
>> + *
>> + * Function prototypes
>> + *
>> + * Copyright (C) 2008 Oracle.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License as published by the Free Software Foundation; either
>> + * version 2 of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
>> +
>> +#ifndef OCFS2_XATTR_H
>> +#define OCFS2_XATTR_H
>> +
>> +#include <linux/init.h>
>> +#include <linux/xattr.h>
>> +
>> +/* Magic value in attribute blocks */
>> +#define OCFS2_XATTR_BLOCK_SIGNATURE_1	"XATTR01"
>> +#define OCFS2_XATTR_BLOCK_SIGNATURE_2	"XATTR02
> 
> Did we still need the "XATTR02" signature? I thought it was taken out of the
> design. Looking through the doc, it's only referenced in an out-dated
> diagram.
Yes, it is from Tiger's original implementation. I will remove it. Thanks.
> 
> 
>> +
>> +enum ocfs2_xattr_type {
>> +	OCFS2_XATTR_INDEX_USER = 1,
>> +	OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS,
>> +	OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
>> +	OCFS2_XATTR_INDEX_TRUSTED,
>> +	OCFS2_XATTR_INDEX_LUSTRE,
>> +	OCFS2_XATTR_INDEX_SECURITY,
>> +	OCFS2_XATTR_MAX
>> +};
>> +
>> +struct ocfs2_xattr_entry {
>> +	__le32	xe_name_hash;
>> +	__le16	xe_name_offset;
>> +	__u8	xe_name_len;
>> +	__u8	xe_type : 7;
>> +	__u8	xe_local : 1;
>> +	__le64	xe_value_size;
>> +};
>> +
>> +struct ocfs2_xattr_header {
>> +	__le16	xh_count;
>> +	__le16	xh_reserved1;
>> +	__le32	xh_csum;
>> +	__le16  xh_reserved2[4];
> 
> Could just be '__u64 xh_reserved2;'
Should be. Will modify it.

Regards,
Tao

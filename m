From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 16 Jul 2008 11:06:41 +0800
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Add incompatible flag for
 extended attribute v2
In-Reply-To: <20080710232228.GE11809@mail.oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-3-git-send-email-tiger.yang@oracle.com>
	<20080710230002.GA32459@wotan.suse.de>
	<20080710232228.GE11809@mail.oracle.com>
Message-ID: <487D65C1.2090803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Joel,

Why we want RO_COMPAT feature with xattr support?
If we make it RO_COMPAT, this means we could only support set xattr in a 
read only ocfs2. But sys_setxattr() need mount writable, so we couldn't 
set xattr at all.

Thanks,
tiger

Joel Becker wrote:
>> Why can't we make XATTR an RO_COMPAT feature?
> 
> 	I agree, it really wants RO_COMPAT.

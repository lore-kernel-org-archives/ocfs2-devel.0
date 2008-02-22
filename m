From: tao.ma <tao.ma@oracle.com>
Date: Fri Feb 22 01:26:03 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Add inode stealing for ocfs2.V1
In-Reply-To: <47BE8EBE.9090100@oracle.com>
References: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
	<47BE89FE.1090204@oracle.com> <47BE8FE1.4070901@oracle.com>
	<47BE8EBE.9090100@oracle.com>
Message-ID: <47BE9517.9020006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



wengang wang wrote:
> tao.ma wrote:
>>
>>
>> wengang wang wrote:
>>> not know it clearly, but I remember when extending a file, meta is 
>>> allocated in extent_alloc instead of inode_alloc if necessary(correct 
>>> me if i am wrong).
>> yes, extending a file using extent_alloc. But I'm stealing inode not 
>> extent block. So don't need to touch extent_alloc.
>>
> extent block needs not being stolen? ;)
This patch series is only for inode stealing(See the patch title), so no 
extent block or extent alloc is touched.
>>> if so, do we need to take extent_alloc into consideration as well?
>> This solution is just for inodes, not extents.
>>>
>>> thanks,
>>> wengang.
>>>
> 

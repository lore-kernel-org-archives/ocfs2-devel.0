From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 05 Feb 2010 10:30:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a refcount condition checking
In-Reply-To: <20100205022332.GA3708@laptop.oracle.com>
References: <201002041330.o145sMME005597@acsinet15.oracle.com>
	<4B6B6D45.30206@oracle.com>
	<20100205022332.GA3708@laptop.oracle.com>
Message-ID: <4B6B82E3.4010209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Wengang Wang wrote:
> Hi Tao,
> 
> On 10-02-05 08:58, Tao Ma wrote:
>> Hi wengang,
>>
>> Wengang Wang wrote:
>>> Hi Joel/Tao,
>>>
>>> I don't know the reflink very well, so please ignore this patch if I am wrong.
>>>
>>> I think in ocfs2_prepare_inode_for_write(), we disable DIO write if the inode
>>> has reflink.
>>> If am right, the way we determine if the inode has reflink is wrong in case
>>> (!has_refcount && direct_io).
>> I just check the caller, all these 2 parameters are either set or NULL  
>> simultaneously. You patch only make sense in (!has_refcount &&  
>> direct_io), but currently we don't have such a case. So why bother  
>> adding redundant code for a not-exist case?
> 
> Yes that current calling has no problem. But such interface has potential danger
> for callers in future.
> If you don't like change code, I think it's better to add comment that
> has_refcount and direct_io must be both NULL or both non-NULL.
Add it please as you wish.

Regards,
Tao

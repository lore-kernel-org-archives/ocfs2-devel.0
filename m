From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue, 23 Sep 2008 10:26:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add nlink check in
	ocfs2_inode_revalidate()
In-Reply-To: <48D80FC2.6030708@oracle.com>
References: <200809220927.m8M9RY10004497@wengang.cn.oracle.com>
	<48D80FC2.6030708@oracle.com>
Message-ID: <48D853D0.2040809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil,

Sunil Mushran wrote:
> NAK
>
> There is no voting in ocfs2 1.4.
>
Agree.
This patch has nothing to do with voting. and it helps nothing on bug 
7029797.
I found these problems when testing with OCFS2/NFS.
> Secondly, i_nlink=0 does not mean inode is deleted. It simply
> means it has no more links. So returning enoent for a valid
> inode would be incorrect.
ha, as my opinion, i_nlink changing from non-zero to zero, the 
inode/file is deleted. maybe it's wrong :)

thanks,
wengang.
>
> wangang wang wrote:
>> nlink should be also checked in ocfs2_inode_revalidate().
>> before setting flag OCFS2_INODE_DELETED ip_flags (between unlink and 
>> delete vote), the nlink may be 0.
>>
>> the patch is against 1.4 git. 1.2 svn should has the same patch with 
>> different line number.
>>
>> Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
>> -- 
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 591e693..6b5a83e 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1186,6 +1186,13 @@ int ocfs2_inode_revalidate(struct dentry *dentry)
>>          status = -ENOENT;
>>          goto bail;
>>      }
>> +
>> +    if (!inode->i_nlink) {
>> +        spin_unlock(&OCFS2_I(inode)->ip_lock);
>> +        mlog(0, "inode deleted!\n");
>> +        status = -ENOENT;
>> +        goto bail;
>> +    }
>>      spin_unlock(&OCFS2_I(inode)->ip_lock);
>>  
>>      /* Let ocfs2_inode_lock do the work of updating our struct
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel  

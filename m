From: jiangyiwen <jiangyiwen@huawei.com>
Date: Wed, 9 Sep 2015 17:14:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fill-in the unused portion of the
 block with zeros by dio_zero_block()
In-Reply-To: <55F0313A020000D400009435@relay2.provo.novell.com>
References: <55EF9184.5090007@huawei.com>
	<55F0313A020000D400009435@relay2.provo.novell.com>
Message-ID: <55EFF86B.2090809@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/9/9 13:16, Zhen Ren wrote:
> Hi Yiwen,
> 
> I try to reproduce this case, but it didn't act like you describe.
> What I did:
> ===
> laptop:/mnt/shared # mount | grep ocfs2
> ocfs2_dlmfs on /dlm type ocfs2_dlmfs (rw,relatime)
> /dev/sda3 on /mnt/shared type ocfs2 (rw,relatime,_netdev,heartbeat=local,nointr,data=ordered,errors=remount-ro,atime_quantum=60,coherency=full,user_xattr,acl)
> laptop:/mnt/shared # dd if=/dev/zero of=/mnt/shared/hello bs=512 count=1 oflag=direct
> 1+0 records in
> 1+0 records out
> 512 bytes (512 B) copied, 0.000684382 s, 748 kB/s
> laptop:/mnt/shared # truncate hello -s 2097152
> laptop:/mnt/shared # cat hello                            ======> nothing
Please use this command to read binary file "hexdump -C /mnt/shared/hello", you will
see the result like this:
linux-ZnXfWq:/mnt/ocfs2 # hexdump -C hello
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00200000
it means in file area 512~4096 is zero not random data.
> laptop:/mnt/shared # uname -r
> 3.16.7-21-desktop
> ===
> 
> Did I do something wrong? If I misunderstand, please correct me.
> Thanks.
> 
>  >>>
>> A simplified test case is (this case from Ryan): 
>> 1) dd if=/dev/zero of=/mnt/hello bs=512 count=1 oflag=direct; 
>> 2) truncate /mnt/hello -s 2097152 
>> file 'hello' is not exist before test. After this command, 
>> file 'hello' should be all zero. But 512~4096 is some random data. 
>>  
>> Setting bh state to new when get a new block, if so, 
>> direct_io_worker()->dio_zero_block() will fill-in the unused portion 
>> of the block with zero. 
>>  
>> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com> 
>> --- 
>>  fs/ocfs2/aops.c | 1 + 
>>  1 file changed, 1 insertion(+) 
>>  
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c 
>> index 1a35c61..bd106b9 100644 
>> --- a/fs/ocfs2/aops.c 
>> +++ b/fs/ocfs2/aops.c 
>> @@ -581,6 +581,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode  
>> *inode, sector_t iblock, 
>>  			ret = -EIO; 
>>  			goto bail; 
>>  		} 
>> +		set_buffer_new(bh_result); 
>>  	} 
>>  
>>  	/* 
>  
> 
> 
> 
> --
> Eric, Ren
> 
> 
> 
> 
> .
> 

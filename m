From: Jensen <shencanquan@huawei.com>
Date: Mon, 1 Jul 2013 09:38:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek requires to ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <20130629133745.GL13405@ZenIV.linux.org.uk>
References: <51C2BC1F.2010106@huawei.com>
	<20130629133745.GL13405@ZenIV.linux.org.uk>
Message-ID: <51D0DD97.5060004@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/29 21:37, Joel Becker wrote:

> On Thu, Jun 20, 2013 at 04:23:59PM +0800, shencanquan wrote:
>> llseek requires ocfs2 inode lock for updating the file size in SEEK_END.
>> because the file size maybe update on another node.
>> if it not . after call llseek in SEEK_END. the position is old.
>>
>> this bug can be reproduce the following scenario:
>> at first ,we dd a test fileA,the file size is 10k.
>> on NodeA:
>> ---------
>> 1) open the test fileA, lseek the end of file. and print the position.
>> 2) close the test fileA
>>
>> on NodeB:
>> 1) open the test fileA, append the 5k data to test FileA.
>> 2) lseek the end of file. and print the position.
>> 3) close file.
>>
>> at first we run the test program1 on NodeA , the result is 10k.
>> and then run the test program2 on NodeB,  the result is 15k.
>> at last, we run the test program1 on NodeA again, the result is 10k.
>>
>> after apply this patch.  the three step result is 15k.
>>
>> Signed-off-by: jensen <shencanquan@huawei.com>
>> ---
>>  fs/ocfs2/file.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index ff54014..3afd24c 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>>  	case SEEK_SET:
>>  		break;
>>  	case SEEK_END:
>> +		/* SEEK_END requires the OCFS2 inode lock for the file
>> +		 * because it references the file's size.
>> +		 */
>> +		ret = ocfs2_inode_lock(inode, NULL, 0);
>> +		if (ret < 0) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>>  		offset += inode->i_size;
>> +		ocfs2_inode_unlock(inode, 0);
> 
> Why wouldn't ocfs2_rw_lock() work?  Just because we dont get the LVB
> from it?
> 


Yes. we want to update the inode size from lvb.

I also think the file size maybe protected by inode lock. not rw lock.

> Joel
> 
>>  		break;
>>  	case SEEK_CUR:
>>  		if (offset == 0) {
>> -- 
>> 1.7.9.7
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 

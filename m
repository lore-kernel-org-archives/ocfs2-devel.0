From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 19 Jul 2013 16:30:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: using i_size_read() to access
	i_size
In-Reply-To: <51E8F4F2.7010205@oracle.com>
References: <1373876172-6467-1-git-send-email-junxiao.bi@oracle.com>
	<51E4B86F.2040703@tao.ma> <51E5D390.6040604@oracle.com>
	<51E8ECF3.7010905@oracle.com> <51E8F2E0.6000207@oracle.com>
	<51E8F4F2.7010205@oracle.com>
Message-ID: <51E8F93B.6050406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/19/2013 04:12 PM, Junxiao Bi wrote:

> Hi Jeff,
> 
> On 07/19/2013 04:03 PM, Jeff Liu wrote:
>> Hi Junxiao,
>>
>> On 07/19/2013 03:38 PM, Junxiao Bi wrote:
>>
>>> Hi Jeff,
>>>
>>> On 07/17/2013 07:13 AM, Jeff Liu wrote:
>>>>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>>>>>>> index 3ce6a8b..7158710 100644
>>>>>>>> --- a/fs/ocfs2/file.c
>>>>>>>> +++ b/fs/ocfs2/file.c
>>>>>>>> @@ -2650,7 +2650,7 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>>>> We have the inode mutex around ocfs2_file_llseek(), and that is too extensive
>>>> to block the concurrent access for particular seek operations.  At least,
>>>> we can get rid of this lock for SEEK_SET/SEEK_CUR. i.e,  In either case,
>>>> we can fall through generic_file_llseek() directly without the mutex lock.
>>> Think about this again, I think we can't remove the mutex, as it is used
>>> to protect other inode member beside i_size, like
>>> inode->i_sb->s_maxbytes which is accessed in all SEEK request and also
>>> more in ocfs2_inode_lock().
>> Thanks for digging into this.  s_maxbytes is a numeric constant which is
>> calculated out at OCFS2 mount with filling up the super blocks, IOWs, it
>> does not need any lock protection IMO.
>>
>> Besides that, could you please pointed me out anything am missed?
> Can inode->i_sb be set to NULL during this?

No, actually when we get into ocfs2_file_llseek(), the corresponding
inode should be in VFS inode cache and it should not be a bad inode
as well, otherwise, it can not go through vfs_llseek(). :)

Thanks,
-Jeff

> 
> Thanks,
> Junxiao.
>>
>> Thanks,
>> -Jeff
>>
>>> Thanks,
>>> Junxiao.
>>>>>>>>  	case SEEK_SET:
>>>>>>>>  		break;
>>>>>>>>  	case SEEK_END:
>>>>>>>> -		offset += inode->i_size;
>>>>>>>> +		offset += i_size_read(inode);
>>
> 

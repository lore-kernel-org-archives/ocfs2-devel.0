From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 19 Jul 2013 17:50:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: using i_size_read() to access
	i_size
In-Reply-To: <51E90402.8080409@oracle.com>
References: <1373876172-6467-1-git-send-email-junxiao.bi@oracle.com>
	<51E4B86F.2040703@tao.ma> <51E5D390.6040604@oracle.com>
	<51E8ECF3.7010905@oracle.com> <51E8F2E0.6000207@oracle.com>
	<51E8F4F2.7010205@oracle.com> <51E8F93B.6050406@oracle.com>
	<51E90402.8080409@oracle.com>
Message-ID: <51E90BE9.1030707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/19/2013 05:16 PM, Junxiao Bi wrote:

> Hi Jeff,
> 
> On 07/19/2013 04:30 PM, Jeff Liu wrote:
>> On 07/19/2013 04:12 PM, Junxiao Bi wrote:
>>
>>> Hi Jeff,
>>>
>>> On 07/19/2013 04:03 PM, Jeff Liu wrote:
>>>> Hi Junxiao,
>>>>
>>>> On 07/19/2013 03:38 PM, Junxiao Bi wrote:
>>>>
>>>>> Hi Jeff,
>>>>>
>>>>> On 07/17/2013 07:13 AM, Jeff Liu wrote:
>>>>>>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>>>>>>>>> index 3ce6a8b..7158710 100644
>>>>>>>>>> --- a/fs/ocfs2/file.c
>>>>>>>>>> +++ b/fs/ocfs2/file.c
>>>>>>>>>> @@ -2650,7 +2650,7 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>>>>>> We have the inode mutex around ocfs2_file_llseek(), and that is too extensive
>>>>>> to block the concurrent access for particular seek operations.  At least,
>>>>>> we can get rid of this lock for SEEK_SET/SEEK_CUR. i.e,  In either case,
>>>>>> we can fall through generic_file_llseek() directly without the mutex lock.
>>>>> Think about this again, I think we can't remove the mutex, as it is used
>>>>> to protect other inode member beside i_size, like
>>>>> inode->i_sb->s_maxbytes which is accessed in all SEEK request and also
>>>>> more in ocfs2_inode_lock().
>>>> Thanks for digging into this.  s_maxbytes is a numeric constant which is
>>>> calculated out at OCFS2 mount with filling up the super blocks, IOWs, it
>>>> does not need any lock protection IMO.
>>>>
>>>> Besides that, could you please pointed me out anything am missed?
>>> Can inode->i_sb be set to NULL during this?
>> No, actually when we get into ocfs2_file_llseek(), the corresponding
>> inode should be in VFS inode cache and it should not be a bad inode
>> as well, otherwise, it can not go through vfs_llseek(). :)
> Thank you for explaining this.
> So for SEEK_SET and SEEK_CUR, we may make some improvement, indeed in
> gereric_file_llseek(), it also use a spin lock to protect concurrent
> SEEK_CUR access.
> is there really a perf issue that deserve us to make a hack to hurt code
> readability?

Sure, and also, I don't think this is *hack*.  Instead, it's an old significant
improvements in VFS generic_file_lseek() from Andi Kleen back to 2011.  Maybe OCFS2
is the only file system without this turn-up as we lack of upstream activity for a
long time.  For detail, please refer to:

commit ef3d0fd27e90f67e35da516dafc1482c82939a60
Author: Andi Kleen <ak@linux.intel.com>
Date:   Thu Sep 15 16:06:48 2011 -0700

    vfs: do (nearly) lockless generic_file_llseek
    
    The i_mutex lock use of generic _file_llseek hurts.  Independent processes
    accessing the same file synchronize over a single lock, even though
    they have no need for synchronization at all.
    
    Under high utilization this can cause llseek to scale very poorly on larger
    systems.
    
    This patch does some rethinking of the llseek locking model:


Thanks,
-Jeff

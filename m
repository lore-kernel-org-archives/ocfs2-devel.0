From: shencanquan <shencanquan@huawei.com>
Date: Tue, 18 Jun 2013 09:03:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek need to inode cluster lock
 and unlock for update the inode size in SEEK_END.
In-Reply-To: <20130617170251.GH29353@wotan.suse.de>
References: <51BF21D6.9080008@huawei.com> <51BF289D.9030706@oracle.com>
	<20130617170251.GH29353@wotan.suse.de>
Message-ID: <51BFB1F2.3040007@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/18 1:02, Mark Fasheh wrote:

> On Mon, Jun 17, 2013 at 11:17:49PM +0800, Jeff Liu wrote:
>> Please add spaces between comments and annotation, i.e,
>> 	   /*  Need to ...... */
> 
> yes, please describe while we're taking the lock here (describing the race
> you're talking about would be fine).
> 
> 
>>> +        ret = ocfs2_inode_lock(inode, NULL, 0);
>>> +        if (ret < 0) {
>>> +            mlog_errno(ret);
>>> +            goto out;
>>> +        }
>>> +        ocfs2_inode_unlock(inode, 0);
>>>           offset += inode->i_size;
>>
>> Why not protect the offset adjustment insides ocfs2 inode locks?
> 
> If we're going through the trouble of locking we *need* to put the offset
> calculation inside the lock otherwise we can still get stale i_size and
> basically haven't fixed anything.
> 
> 
> Btw, do you feel that this could impact performance for other workloads that
> ocfs2 usually does?


I think it maybe impact performance. because it use the cluster lock and
it maybe flush the inode cache to disk and read the inode from disk. but
I think the correct function of llseek is more important.


> 	--Mark
> 
> --
> Mark Fasheh
> 
> 

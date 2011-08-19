From: Jeff liu <jeff.liu@oracle.com>
Date: Fri, 19 Aug 2011 22:32:24 +0800
Subject: [Ocfs2-devel] Feature Request for cp(1) utility,
	consider Btrfs ioctl clone range support
In-Reply-To: <78EF093E-C872-4209-B784-A20095D3D44A@oracle.com>
References: <4E42500D.3050702@oracle.com> <4E4E6C3E.50606@draigBrady.com>
	<78EF093E-C872-4209-B784-A20095D3D44A@oracle.com>
Message-ID: <CDD04050-C4A7-4E1D-8449-4DE9596160D9@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

btw, I have posted a patch to make cp --reflink option works for OCFS2 too,
http://lists.gnu.org/archive/html/coreutils/2011-05/msg00017.html

Is it acceptable?


Thanks,
-Jeff

> Hi P?draig,
> 
> Thanks for your comments!
> 
>> On 08/10/2011 10:31 AM, Jeff Liu wrote:
>>> Hello,
>>> 
>>> I just found a cool feature in Btrfs for cloning partially source file
>>> to the destination by specifying the desired offset and length to be copied.
>>> 
>>> The call interface is something like below:
>>> struct btrfs_clone_range_args cr;
>>> cr.src_fd = source_desc;
>>> cr.src_offset = (uint64_t) offset;
>>> cr.src_length = (uint64_t) length;
>>> cr.dest_offset = (uint64_t) d_offset;
>>> ioctl(dest_fd, BTRFS_IOC_CLONE_RANGE, &args);
>>> 
>>> cp(1) has already works with "reflink" supported for a long time, IMHO,
>>> this new feature could improve it to some extent.
>>> Is it acceptable to add a new option like
>>> "--reflink-range=src_offset,src_length,dst_offset" to clone partially
>>> source file?
>>> In this way, if reflink-range is triggered, cp(1) will try to parse the
>>> offset and length which are separated by comma,
>>> then try to clone src_length bytes from src_offset to the destination
>>> file started at dst_offset.
>>> if reflink-range failed, just let cp(1) fail with appropriate error info.
>>> 
>>> I'd like to implement it if you guys think it does make sense. :-P.
>> 
>> IMHO I don't think this level of control is needed in `cp`.
> 
> If you think it became useful to other coreutils stuff in the future, please let me know, I would like to work on it.
> 
> Regards,
> -Jeff
>> 
>> cheers,
>> P?draig.
> 
> 

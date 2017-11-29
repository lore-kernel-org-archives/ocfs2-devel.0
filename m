From: alex chen <alex.chen@huawei.com>
Date: Wed, 29 Nov 2017 12:37:34 +0800
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
	/build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <1511879691.2799.1.camel@nixnuts.net>
References: <1511204090.3644.6.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
	<1511232309.3644.14.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CDDB@H3CMLB14-EX.srv.huawei-3com.com>
	<1511298301.2735.1.camel@nixnuts.net> <5A17B220.5030909@huawei.com>
	<1511879691.2799.1.camel@nixnuts.net>
Message-ID: <5A1E398E.7090701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi John,

On 2017/11/28 22:34, John Lightsey wrote:
> On Fri, 2017-11-24 at 13:46 +0800, alex chen wrote:
>> We need to check the free number of the records in each loop to mark
>> extent written,
>> because the last extent block may be changed through many times
>> marking extent written
>> and the num_free_extents also be changed. In the worst case, the
>> num_free_extents may
>> become less than at the beginning of the loop. So we should not
>> estimate the free
>> number of the records at the beginning of the loop to mark extent
>> written.
>>
>> I'd appreciate it if you could test the following patch and feedback
>> the result.
> 
> I managed to reproduce the bug in a test environment using the
> following method. Some of the specific details here are definitely
> irrelevant:
> 
> - Setup a 20GB iscsi lun going to a spinning disk drive.
> 
> - Configure the OCFS cluster with three KVM VMs.
> 
> - Connect the iscsi lun to all three VMs.
> 
> - Format an OCFS2 partition on the iscsi lun with block size 1k and
> cluster size 4k.
> 
> - Mount the OCFS2 partition on one VM.
> 
> - Write out a 1GB file with a random pattern of 4k chunks. 4/5 of the
> 4k chunks are filled with nulls. 1/5 are filled with data.
> 
> - Run fallocate -d <filename> to make sure the file is sparse.
> 
> - Copy the test file so that the next step can be run repeatedly with
> copies.
> 
> - Use directio to rewrite the copy of the file in 64k chunks of null
> bytes.
> 
> 
> In my test setup, the assertion failure happens on the next loop
> iteration after the number of free extents drops from 59 to 0. The call
> to ocfs2_split_extent() in ocfs2_change_extent_flag() is what actually
> reduces the number of free extents to 0. The count drops all at once in
> this case, not by 1 or 2 per loop iteration.
> 
> With your patch applied, it does handle this sudden reduction in the
> number of free extents, and it's able to entirely overwrite the 1GB
> file without any problems.

Thanks for your test.

> 
> Is it safe to bring up a few nodes in our production OCFS2 cluster with
> the patched 4.9 kernel while the remainder nodes are running a 3.16
> kernel?
>

IMO, it is best to ensure the kernel version of nodes in the cluster is consistent.

> The downtime required to switch our cluster forward to a 4.9 kernel and
> then back to a 3.16 kernel is hard to justify, but I can definitely
> test one or two nodes in our production environment if it will be a
> realistic test.
> 
I think this patch is only tested in one node because we lock the inode_lock
when we make the extent written.

Thanks,
Alex

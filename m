From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 18 Nov 2010 10:08:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Stop tracking a negative
 dentry after dentry_iput().
In-Reply-To: <4CE48469.2090102@oracle.com>
References: <1289828349-24098-1-git-send-email-tristan.ye@oracle.com>
	<20101117232344.GF25677@mail.oracle.com>
	<4CE48469.2090102@oracle.com>
Message-ID: <4CE48A84.3090405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan Ye wrote:
> Joel Becker wrote:
>> On Mon, Nov 15, 2010 at 09:39:09PM +0800, Tristan Ye wrote:
>>> I suddenly hit the problem during 2.6.37-rc1 regression test, which was
>>> introduced by commit '5e98d492406818e6a94c0ba54c61f59d40cefa4a'(Track
>>> negative entries v3), following scenario reproduces the issue easily:
>>>
>>> Node A            Node B
>>> ================    ============
>>> $touch     testfile   
>>>             $ls testfile
>>> $rm -rf testfile
>>> $touch     testfile   
>>>             $ls testfile
>>>             ls: cannot access testfile: No such file or directory
>>>
>>> This patch stops tracking the dentry which was negativated by a 
>>> inode deletion,
>>> so as to force the revaliation in next lookup, in case we'll touch 
>>> the inode
>>> again in the same node.
>>>
>>> It didn't hurt the performance of multiple lookup for none-existed 
>>> files anyway,
>>> while regresses a bit in the first try after a file deletion.
>>
>>     I'm going to take this fix for now, because it is clearing the
>> problem.  However, it looks like the original code _should_ work.  If we
>> have created a file, the directory's generation should have been
>> updated.  Thus, the pgen shouldn't match the generation set when the old
>> inode was deleted.  Right?
I'm afraid it was not the case,

Say nodeA deleted the file(after Node B 'ls' it), Yes, now the 
generation number of
parent directory gets updated, and the newly-generated negative dentry 
inherits the
pgen, then we continue to do the creation(touch file) on nodeA without 
nodeB interleaves
the operation at all. in this case, pgen will not change since no 
dlmlock gets converted here,
reasonable?


Tristan.

>
> Yep,
>
> Original code did work of course, 

I may misunderstand you words a little bit here, I meant 'original code' 
is the codes before goldwyn's patch
being applied.

> goldwyn's patch just tries to improve the performance by
> reducing the possibility of calling revalidation for negative dentries 
> on multiple lookups
> on none-existed files.
>
> If we created a file, the directory's generation only changes in the 
> ocfs2_data_convert_worker,
> which only happens when a node doing lock conversion, it means the 
> pgen will not change if a node
> creates the node without a dlmlock being converted.
>
>
> Tristan.
>>
>> Joel
>>
>>
>

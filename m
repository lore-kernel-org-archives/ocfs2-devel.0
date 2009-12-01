From: Coly Li <coly.li@suse.de>
Date: Tue, 01 Dec 2009 16:22:39 +0800
Subject: [Ocfs2-devel] what is global bitmap, block group, suballocator,
 etc
In-Reply-To: <4B0CE3F2.8040503@oracle.com>
References: <4B0CE011.3030403@suse.de> <4B0CE3F2.8040503@oracle.com>
Message-ID: <4B14D24F.5090604@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tao,

Thanks for your reply. I spent some time to read the code and understand :)

On 2009?11?25? 15:59, Tao Ma Wrote:
> Hi Coly,
> 
> Coly Li wrote:
>> Hi list,
>>
>> There are some ocfs2 terminologies that I don't understand very well.
>> After checking the ocfs2 wiki and kernel/tools
>> code, I am still not sure whether I understand them correctly.
>>
>> - Global bitmap
>>   What's the usage of global bitmap? Which kind of resource allocation
>> will set global bitmap?
> global bitmap is a system file which indicates the usage of clusters in
>  the whole volume. It is a chain file. So it has a ocfs2_chain_list in
> its ocfs2_dinode.id2. And the chain_list is a chain of many groups. A
> group is a range of clusters and the 1st block of a group has a bitmap
> to indicate which cluster(or block, cpg is used here) is allocated or not.

What is a chain file ? Is it a file not for regular file data storage (a.k.a dinode->i_size == 0), but to record
allocation chains of an ocfs2 volume (a.k.a dinode->id2.i_chain) ?

Another question is, for each node (slot), should it have only 1 chain file ? If yes, I guess the chain number limit is
ocfs2_chain_recs_per_inode().


-- 
Coly Li
SuSE Labs

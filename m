From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 14 Aug 2008 09:13:54 +0800
Subject: [Ocfs2-devel] [PATCH] Refactor ocfs2_insert_extent for
	not-merging.
In-Reply-To: <20080813203240.GO21187@wotan.suse.de>
References: <20080812205225.GH21187@wotan.suse.de>
	<1218648792-5033-1-git-send-email-tao.ma@oracle.com>
	<20080813203240.GO21187@wotan.suse.de>
Message-ID: <48A386D2.40108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Thu, Aug 14, 2008 at 01:33:12AM +0800, Tao Ma wrote:
>   
>> From: taoma <taoma@tma-home.cn.oracle.com>
>>
>> Hi Mark,
>> 	Here is the patch we discussed this morning.
>>
>> In xattr bucket, we want to limit the maximum size of a btree leaf,
>> otherwise we'll lose the benefits of hashing because we'll have to search
>> large leaves.
>>
>> So add a new flag in ocfs2_extent_tree which will prevent ocfs2_insert_extent
>> from merging the leaf record even if they are contiguous.
>>     
>
> Ok, this is close... The problem I see here though is that we've gone from
> always merging when possible to *never* merging.
>
> What we want is "don't merge if the resulting extent is larger than a given
> size".
>   
I leave this judgement to the caller itself(the flag) and I think the 
caller should be responsible for telling ocfs2_insert_extent whether the 
new added cluster should be merged or not.
So if the caller say loudly that "please don't merge", we will not 
merge. As for xattr extent tree, I have already judge the situation in 
the caller(ocfs2_add_new_xattr_cluster), so it will not be a problem.
There is also another benefit. In future, other extent tree type may 
have another type of things which will ask ocfs2_insert_extent to "not 
merge", but not because of the leaf size. And we can also handle this.
Make sense?

Regards,
Tao

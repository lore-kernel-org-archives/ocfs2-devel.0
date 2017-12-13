From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 13 Dec 2017 04:51:17 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: clean dead code in suballoc.c
References: <63ADC13FD55D6546B7DECE290D39E373F1F5A842@H3CMLB14-EX.srv.huawei-3com.com>
	<b0e71d54-2948-5b21-7a41-b77b36d0a679@gmail.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F5A8AF@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2017/12/13 12:03, Joseph Qi wrote:
> 
> 
> On 17/12/13 11:51, Changwei Ge wrote:
>> Stack variable fe is no longer used, so trim it to save some cpu cycles
>> and stack space.
>>

>> -	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb,
>> ocfs2_blocks_to_clusters(bitmap_inode->i_sb, start_blk)));
> 
> Still malformed. You have to disable auto wrap length in your editor.

Hi Joseph,
Thanks for your tips, I will send a revised patch later.

Thanks,
Changwei

> 
> Thanks,
> Joseph
> 
>> +	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb,
>> +				ocfs2_blocks_to_clusters(bitmap_inode->i_sb,
>> +							 start_blk)));

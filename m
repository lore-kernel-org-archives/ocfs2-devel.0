From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 17 Dec 2009 22:00:07 +0800
Subject: [Ocfs2-devel] ocfs2: add extent block stealing for ocfs2 v1
In-Reply-To: <4B29FE85.1070704@oracle.com>
References: <4B2617D0.7060504@oracle.com> <4B274325.1050505@oracle.com>
	<4B29FE85.1070704@oracle.com>
Message-ID: <4B2A3967.4020600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jun Yang wrote:
> On 12/15/2009 04:04 PM, Tao Ma wrote:
>> alloc_group = osb->osb_inode_alloc_group;
>> here, you use the alloc_group which is only used in inode alloc and
>> reset it
>> after the reservation succeed. I am afraid extent alloc shouldn't use 
>> and
>> change it?
> Yes, It's a mistake. It seems I would better not merge those two 
> functions.
oh, you can merge them. Just make sure not mess extent_alloc with 
inode_alloc.
>
>> I am also curious about one thing. Have you written the test script for
>> it to see whether it works?
>> You can take ocfs2-tests/programs/inode_stealing/inode_stealing.sh for
>> reference.
> thanks for your advice. I will make a similar test for extent block 
> stealing patches.
cool.

Regards,
Tao

From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 01 Apr 2010 12:39:35 +0800
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <20100401043431.GA2629@laptop.oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
	<20100401043431.GA2629@laptop.oracle.com>
Message-ID: <4BB42387.6060404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi wengang,

Wengang Wang wrote:
> On 10-04-01 12:22, Tao Ma wrote:
>> Hi Joel,
>>
>> Joel Becker wrote:
>>> On Thu, Apr 01, 2010 at 10:59:10AM +0800, Tao Ma wrote:
>>>> ocfs2_group_bitmap_size has to handle the case when the
>>>> volume don't have discontiguous block group support.
>>> 	NAK.  We specify 256 in all cases.  This doesn't hurt old code
>>> because we've never used more bits.  Even though our old bg_size values
>>> were much larger, we never used that space because bg_bits was set to
>>> the smaller value.
>> No, it hurts.
> 
> Hi, 
>> So with an old ocfs2-tools and a new kernel, the new kernel will set it 
>> to 256 while the old ocfs2-tools refused to work by checking bg_size(see
>> chainalloc_process_group in libocfs2).
> 
> Just for my info.
> Is "old ocfs2-tools + new kernel" supported?
I guess yes? I am not sure whether a user can use a 2.6.35 kernel(the 
next merge window) while using an ocfs2-tools 1.4.

Regards,
Tao

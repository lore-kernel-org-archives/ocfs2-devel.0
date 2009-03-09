From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 09 Mar 2009 18:48:35 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two bug fixes about xattr and
 inline-data
In-Reply-To: <49B4F1EB.4060601@oracle.com>
References: <49ADF2FB.6060503@oracle.com>		<20090305023617.GA18729@mail.oracle.com>		<1236572226.6816.30.camel@tristan-laptop.cn.oracle.com>		<49B4A1B8.10806@oracle.com>		<1236575084.6816.35.camel@tristan-laptop.cn.oracle.com>		<49B4AC58.4090400@oracle.com>		<1236579270.6816.39.camel@tristan-laptop.cn.oracle.com>		<49B4B8B8.7030108@oracle.com>	<20090309064711.GB27610@mail.oracle.com>	<1236581684.6816.45.camel@tristan-laptop.cn.oracle.com>	<49B4BF02.3080100@oracle.com>	<49B4C41B.1060708@oracle.com>	<49B4F123.8070204@oracle.com>
	<49B4F1EB.4060601@oracle.com>
Message-ID: <49B4F403.5070907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Wengang Wang wrote:
>> He runs the command "dd if=/dev/zero of=testfile bs=1 count=3641" which 
>> can not hit the bug2. But I found "dd if=/dev/zero of=testfile bs=3641 
>> count=1" will hit the bug2.
> 
> 3641, cool number!
Hey, 3641 is the max_inline_size_with_xattr + 1 when bs = 4K. ;) So you 
see, they create it intentionally.

Regards,
Tao

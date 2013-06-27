From: shencanquan <shencanquan@huawei.com>
Date: Thu, 27 Jun 2013 09:50:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek requires to ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <20130626182536.c319334d.akpm@linux-foundation.org>
References: <51C2BC1F.2010106@huawei.com>
	<20130626141803.a67cb8e4ca38a9ef2967a448@linux-foundation.org>
	<51CB9338.3050408@huawei.com>
	<20130626182536.c319334d.akpm@linux-foundation.org>
Message-ID: <51CB9A81.2000007@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/27 9:25, Andrew Morton wrote:

> On Thu, 27 Jun 2013 09:19:52 +0800 shencanquan <shencanquan@huawei.com> wrote:
> 
>> On 2013/6/27 5:18, Andrew Morton wrote:
>>
>>>
>>> My guess is that there is some other code path which is modifying
>>> inode->i_size without holding inode->i_mutex, and while holding
>>> ocfs2_inode_lock().  If so, that code is surely wrong - it should hold
>>> i_mutex while modifying i_size.
>>
>>
>> inode->i_mutex lock only protect the inode size on the same machine.
> 
> ah ;)
> 
>>> And all this is only really applicable to 32-bit CPUs, which you
>>> probably aren't using.
>>
>> I don't understand this.
> 
> The i_size_read/i_size_write infrastructure is designed to efficiently
> handle the situation where a 32-bit machine reads a 64-bit number which
> might be undergoing modification on another CPU.  We don't want the
> reading CPU to see an invalid number when the writing CPU is in the
> middle of modifying the two 32-bit words.
> 
> 
> 

ok. thanks.

From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 12 Oct 2010 06:01:11 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add a mount option
 "coherency=*" to handle cluster coherency for O_DIRECT writes.
In-Reply-To: <20101011211643.GH4255@mail.oracle.com>
References: <1286786799-10230-1-git-send-email-tristan.ye@oracle.com>
	<20101011211643.GH4255@mail.oracle.com>
Message-ID: <4CB38927.2070403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
Joel Becker wrote:
> On Mon, Oct 11, 2010 at 04:46:39PM +0800, Tristan Ye wrote:
>   
>> Currently, default behavior of O_DIRECT writes was allowing
>> concurrent writing among nodes, no cluster coherency guaranteed
>> (no EX locks was taken), it hurts buffered reads on other nodes
>> by reading stale data from cache.
>>
>> The new mount option introduce a chance to choose two different
>> behaviors for O_DIRECT writes:
>>
>>     * coherency=full, as the default value, will disallow
>>                       concurrent O_DIRECT writes by taking
>>                       EX locks.
>>
>>     * coherency=buffered, allow concurrent O_DIRECT writes
>>                           without EX lock among nodes, which
>>                           gains high performance at risk of
>>                           getting stale data on other nodes.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>     
>
> 	This patch is now in the merge-window branch of ocfs2.git.
>   
I think that you agree with me that we only need to take PR lock in 
full_coherency, but this patch
still try the exclusive one. So do I miss something?

Regards,
Tao

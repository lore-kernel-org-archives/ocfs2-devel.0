From: Eric Ren <zren@suse.com>
Date: Mon, 23 Oct 2017 14:51:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: mknod: fix recursive locking hung
In-Reply-To: <36080fe1-8556-a6da-4b76-13f40efb7c44@oracle.com>
References: <1508300302-5155-1-git-send-email-junxiao.bi@oracle.com>
	<59E74BFF020000F90009353F@prv-mh.provo.novell.com>
	<36080fe1-8556-a6da-4b76-13f40efb7c44@oracle.com>
Message-ID: <baf97568-8385-1594-d564-7b2984a07400@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 10/18/2017 12:44 PM, Junxiao Bi wrote:
> On 10/18/2017 12:41 PM, Gang He wrote:
>> Hi Junxiao,
>>
>> The problem looks easy to reproduce?
>> Could you share the trigger script/code for this issue?
> Please run ocfs2-test multiple reflink test.
Hmm, strange, we do run ocfs2-test quite often.

Eric

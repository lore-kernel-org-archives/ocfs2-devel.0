From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 11 Mar 2010 11:21:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: prints peer node number when
 sending tcp msg failed
In-Reply-To: <4B97E14E.3070902@oracle.com>
References: <201003101313.o2ACClp1019681@acsinet15.oracle.com>
	<4B97E14E.3070902@oracle.com>
Message-ID: <20100311032125.GA2497@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-03-10 10:13, Sunil Mushran wrote:
> Yes knowing the node number will be very useful.
> 
> Wondering why not just have the mlog in o2net_send_message_vec().
> Fewer changes. Do you see any downside?

No very good reason just that I think there is rule that callers print
the error number returned by the callee.

If the above doesn't matter, of course your suggestion is better.

Or you meant we print the errno returned by o2net_send_tcp_msg() with
node number in o2net_send_message_vec()?

regards,
wengang.
 
> Wengang Wang wrote:
> >This patch adds prints of the number of peer node to which sending tcp message
> >failed. It helps debugging.

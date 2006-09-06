From: Mathieu Avila <mathieu.avila@seanodes.com>
Date: Wed Sep  6 00:12:47 2006
Subject: [Ocfs2-devel] heartbeat.
Message-ID: <44FE73D5.2020602@seanodes.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello OCFS2 team,

I'm currently looking at the OCFS2 code in linux-2.6.17.11, and i wander 
why OCFS2 performs its heartbeat on a disk region unlike on the network 
like many clustered services stack do. What is the requirement for a 
disk heartbeat ? Is there any way to tune this behaviour and change it 
into a network heartbeat ?

--
Mathieu

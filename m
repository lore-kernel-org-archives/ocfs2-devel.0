From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 13 May 2009 12:12:01 -0700
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode()	call
In-Reply-To: <4A0B1529.6030701@telecom.by>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
	<4A0AFEB4.2080000@telecom.by>
	<20090513183924.GE32316@mail.oracle.com>
	<4A0B1529.6030701@telecom.by>
Message-ID: <4A0B1B81.8080908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Oleg Gawriloff wrote:
> May 13 21:35:35 falcon-cl5 (5820,2):dlm_do_recovery:524 (5820) Node 4 
> is the Recovery Master for the Dead Node 0 for Domain 
> 558A175E1CC94570940D9BEFCAE48B8E
> May 13 21:35:43 falcon-cl5 (9367,1):ocfs2_replay_journal:1470 
> Recovering node 0 from slot 2 on device (8,64)
> May 13 21:35:43 falcon-cl5 (9368,0):ocfs2_replay_journal:1470 
> Recovering node 0 from slot 2 on device (8,48)
> May 13 21:35:43 falcon-cl5 (9369,3):ocfs2_replay_journal:1470 
> Recovering node 0 from slot 2 on device (8,32)
> May 13 21:35:54 falcon-cl5 kjournald2 starting: pid 9370, dev sde:38, 
> commit interval 5 seconds
> May 13 21:35:54 falcon-cl5 kjournald2 starting: pid 9371, dev sdd:166, 
> commit interval 5 seconds
> May 13 21:35:54 falcon-cl5 (9367,3):ocfs2_begin_quota_recovery:374 
> Beginning quota recovery in slot 2
> May 13 21:35:54 falcon-cl5 (9368,2):ocfs2_begin_quota_recovery:374 
> Beginning quota recovery in slot 2
> May 13 21:35:54 falcon-cl5 kjournald2 starting: pid 9372, dev sdc:38, 
> commit interval 5 seconds
> May 13 21:35:55 falcon-cl5 (9369,5):ocfs2_begin_quota_recovery:374 
> Beginning quota recovery in slot 2
> May 13 21:35:55 falcon-cl5 (3127,2):ocfs2_finish_quota_recovery:564 
> Finishing quota recovery in slot 2
> May 13 21:35:56 falcon-cl5 (3127,4):ocfs2_finish_quota_recovery:564 
> Finishing quota recovery in slot 2
> May 13 21:35:56 falcon-cl5 (3127,4):ocfs2_finish_quota_recovery:564 
> Finishing quota recovery in slot 2
> May 13 21:35:57 falcon-cl5 o2net: connected to node falcon-cl1 (num 0) 
> at 172.16.2.228:7777
> May 13 21:36:01 falcon-cl5 ocfs2_dlm: Node 0 joins domain 
> 558A175E1CC94570940D9BEFCAE48B8E
> May 13 21:36:01 falcon-cl5 ocfs2_dlm: Nodes in domain 
> ("558A175E1CC94570940D9BEFCAE48B8E"): 0 1 4
> May 13 21:36:05 falcon-cl5 ocfs2_dlm: Node 0 joins domain 
> 0AF561B8464D47C78DCC544ADC5273A5
> May 13 21:36:05 falcon-cl5 ocfs2_dlm: Nodes in domain 
> ("0AF561B8464D47C78DCC544ADC5273A5"): 0 1 4
> May 13 21:36:10 falcon-cl5 ocfs2_dlm: Node 0 joins domain 
> A474A15478334D959A30A50ED6530ABE
> May 13 21:36:10 falcon-cl5 ocfs2_dlm: Nodes in domain 
> ("A474A15478334D959A30A50ED6530ABE"): 0 1 4
> May 13 21:38:54 falcon-cl5

How did you enable quotas? While the fs has support for it, the tools don't.
Meaning users cannot enable it using the tools as-is.

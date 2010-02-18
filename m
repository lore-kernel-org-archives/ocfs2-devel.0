From: srinivas eeda <srinivas.eeda@oracle.com>
Date: Wed, 17 Feb 2010 17:46:50 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message
	protocol
In-Reply-To: <4B7C9310.6050201@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>	<1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>	<20100217055641.GI13798@mail.oracle.com>
	<4B7C345E.6000504@oracle.com> <4B7C706F.7060807@oracle.com>
	<4B7C732A.8000204@oracle.com> <4B7C720E.3060401@oracle.com>
	<4B7C7F94.206@oracle.com> <4B7C80C1.4060400@oracle.com>
	<4B7C90F5.5000909@oracle.com> <4B7C9310.6050201@oracle.com>
Message-ID: <4B7C9C0A.1040502@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

whenever a message is received o2net_process_message will call 
o2net_sc_postpone_idle to cancel/requeue keepalive message. What will 
happen if the 2 seconds have passed right before the cancel was issued. 
Will the work gets queued which will be executed later by o2net thread 
or will o2net thread gets interrupted and will execute this work? or can 
both codes be executed in parallel?

On 2/17/2010 5:08 PM, Sunil Mushran wrote:
> srinivas eeda wrote:
>> Ok, I'll modify the patch. Are messages queued on o2net_wq and 
>> execution of o2net_process_message is always done in the context of 
>> o2net thread and are synchronized?
>>
> o2net is the context. Synchronized?

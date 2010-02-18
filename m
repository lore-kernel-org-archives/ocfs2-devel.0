From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Feb 2010 17:08:32 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message
	protocol
In-Reply-To: <4B7C90F5.5000909@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>	<1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>	<20100217055641.GI13798@mail.oracle.com>
	<4B7C345E.6000504@oracle.com> <4B7C706F.7060807@oracle.com>
	<4B7C732A.8000204@oracle.com> <4B7C720E.3060401@oracle.com>
	<4B7C7F94.206@oracle.com> <4B7C80C1.4060400@oracle.com>
	<4B7C90F5.5000909@oracle.com>
Message-ID: <4B7C9310.6050201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

srinivas eeda wrote:
> Ok, I'll modify the patch. Are messages queued on o2net_wq and 
> execution of o2net_process_message is always done in the context of 
> o2net thread and are synchronized?
>
o2net is the context. Synchronized?

From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jan  9 11:15:36 2008
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add dlm context printing in
	dlm debug
In-Reply-To: <47806870.5070007@oracle.com>
References: <47806870.5070007@oracle.com>
Message-ID: <20080109191503.GE23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jan 06, 2008 at 01:34:40PM +0800, wengang wang wrote:
> add dlm context printing support in dlm debugging

Great, I like that you've added the ability for us to show these.


> - echo 'd' >/proc/fs/ocfs2_dlm/debug prints all dlm contexts.
> - echo 'D UUID' >/proc/fs/ocfs2_dlm/debug prints the context of the 
> specified dlm

We took out all the /proc/ code in the mainline Ocfs2 code. This patch would
be fine for 1.2 though and we can work out what to do in mainline/1.4 later.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com

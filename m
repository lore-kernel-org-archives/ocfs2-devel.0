From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 14:13:16 2004
Subject: [Ocfs2-devel] About Mark's advice on bug 48
In-Reply-To: <4063E97B.7020100@intel.com>
References: <4063DB4B.6060000@intel.com> <4063E97B.7020100@intel.com>
Message-ID: <20040329201311.GU10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2004 at 04:27:39PM +0800, Sonic Zhang wrote:
> Hi Mark,
> 
> Yes, I find the code in ocfs_daemonize() to allow kernel thread to 
> receive signals. So, I change the signal process code to make it 
> compilable under kernel 2.6. Please check my revise.
Ahh, ok the 2.6 compatibility stuff I definitely missed. I'll commit the
change with that in it. Thanks for testing / revising this.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com

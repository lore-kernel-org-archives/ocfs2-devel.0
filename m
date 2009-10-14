From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 14 Oct 2009 09:07:49 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: add trace event support for
 ocfs2
In-Reply-To: <20091013203346.GC23257@mail.oracle.com>
References: <200909170419.n8H4JFWY027973@rgminet13.oracle.com>
	<20091013203346.GC23257@mail.oracle.com>
Message-ID: <4AD52465.9010104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Joel Becker wrote:
> On Thu, Sep 17, 2009 at 06:19:44AM +0800, Wengang Wang wrote:
>> following patches add trace event support for ocfs2.
> 
> Wengang,
> 	This looks like a nice start.  Thank you for getting this going.
> I'm sorry I haven't gotten back until now, I've been busy.

Joel, no problem!

> 	What I'd like to do next is get a small starting set of
> tracepoints.  You have one tracepoint in this patch as a good example,
> but we should get a few more.  I don't want every mlog changed into a
> tracepoint.  Some of them are old and useless :-)  Instead, I'd like to
> find information we often want while debugging.

yes, I understand that.

> 	Tao, Tiger, and Sunil, what are parts of the code you often come
> across when debugging?  Certain mlog() prints you always find really
> important to see.  If you point them out, Wengang can cook up
> tracepoints for them.

and yes, welcome to give me suggests for the trace points!!

regards,
wengang.

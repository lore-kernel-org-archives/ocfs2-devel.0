Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9EDC677F1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4ae+P6tF72bG/+WC9HoAPonwOpIWM6RZCa1wF3OSank=;
 b=OCrKVdZyEqGcS0FH1/ZyXRKW9720miGpkWODLG+/dF3oWVKQ3zgJjtK2Jq1OdTet4+vEA4iwBueu
   /yfL8CvVIF3881g9LPo9f2DqcZp6gsbGrfMe9tRoGv35KjIL6UswssSeZlQp5n/e3Q8/VD16Q1mx
   2Me9DIybjRJbX1HvgVNrEJOaGfIpCq33YUk3f0nLlgFxOwYqXCgrYGXc6c9gKCAX0vhrpNuNpASi
   pGPbnE7TW/36DRaOg6X03EXpq5YSJC4DeTqIbbbmlntQ1qNn7ISzx2LGh+WkKym4myAVGXlpWmx5
   fvfx7hzEuApZ+s/olre61Tm4sj99kb4ZBWsoWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4ae+P6tF72bG/+WC9HoAPonwOpIWM6RZCa1wF3OSank=;
 b=OKSJquy57ZhSQ552YFRBGIQlejNEGuSe66wGuXHDxOAobd05Z7oybwde5bFd/R+a4wQJRoaPYBQr
   hzftwLSIa1IEjrKmW9IhkKBv1HozdeypCJR6TiWH0zGJ29jX+P17pNdsDkn5RzAePVWNXAFWiadB
   OWkxNovlECnO8GpcGXIQnSyjJjmEBHcAZIYKK3jMVnhzvyoitNElSQj9eBDaRvUdzPXn200TJ3Tn
   Yiz/kjCcdUGCI3X7lIYsH2iOArqmzgOZorw2tN4PjxNCUkIngJ+PzieEVYpQ/jo0O0LXhvV3Mq19
   Jcem1pN5xEbA8P7B3p5RAS+3QnIfMKF28l3P/A==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROC005QT0BSGQ30@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 17:23:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=/B/lUwSLDdy4TKNacqRrqVdQIO2bhHf2Dz5b7u6s8PE=; b=bcql4AlYVAJfMUZcdgk78k/Yny
 q4YxTySo08vOzZJbXrcUsvwxHEdzxgb+Ii1pvB23J18DFaDaSxWwBDTwyZecKpMjpzQSj9cSdzwmB
 E7FeOscjYnn+NHlMhzBHTcQyUCHILWDwxB3r/wjmCpMi1dOhxzWkdzfdVZaVaLtHEn2WfhcBSiMoJ
 xaR4xsr0iH8jHbII4QbOQBd/z6Ffk95rwXeSJqAugvrLrUzd2S6So2J6l2wpGNMPAo+GmrZbGZYy2
 3br39DqBSOcN8JgFwxhPiVl/2Ubg9nDcfM/BSKfMobkmQa8ifVIF5567jY8IZeuTcc+4AkuGErYD7
 D1ThFcXw==;
Date: Wed, 11 Jan 2023 11:29:35 +0000
To: Jeff Layton <jlayton@kernel.org>
Message-id: <Y76dnx07NGAS2jqG@shell.armlinux.org.uk>
References: <20230105211937.1572384-1-jlayton@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230105211937.1572384-1-jlayton@kernel.org>
X-Source-IP: 78.32.30.218
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=177 impostorscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301110085
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 linux-xfs@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 linux-cifs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-afs@lists.infradead.org,
 cluster-devel@redhat.com, Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, linux-nfs@vger.kernel.org,
 Tom Talpey <tom@talpey.com>, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 linux-arm-kernel@lists.infradead.org, Christian Brauner <brauner@kernel.org>,
 Paulo Alcantara <pc@cjr.nz>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chuck Lever <chuck.lever@oracle.com>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, Bob Peterson <rpeterso@redhat.com>,
 Steve French <stfrench@microsoft.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] filelock: move file locking definitions
 to separate header file
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: "Russell King \(Oracle\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Russell King \(Oracle\)" <linux@armlinux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: pandora.armlinux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 38-52m9wdVVvYof1q4iAwhEO1z25iOHj
X-Proofpoint-GUID: 38-52m9wdVVvYof1q4iAwhEO1z25iOHj
X-Mailman-Approved-At: Wed, 11 Jan 2023 17:23:49 +0000
Reporting-Meta:
 AAGwVvAPUbowzOp006cK5ta00gD8gMlFu+mZGtAuzG8oB2Eg47RTLxkOTu2aHO0O
 dwHbLtr7KQ9HBHb64a6Gr4jJmzg9pzndRG4CHhykTiKZfMDgSl2DyTnsGFbcJ/Fc
 RgUqNLhtJ1H0Ea9fG+vuShGnxag0hIVW8I/baKpyQC3L8qwzhCCvg0+h/JRl2w/e
 wI15Lfzs8Red9ap/JHGrwRlajEbp07M8/hqqzEdyEWDHJx7cnD146KqixjvLPSY5
 vsS6F4Z1Q5BugavuQD+znwftb/gVmndybVbO5VkL1F9c1VaYgliUCJT2hc5njcVA
 KItJHjf7Q4p7Xo+IhQ4C1eZAKaHR8Ria2OqL6quqwWGXtr4pOlZxwiPMNUv/XFEf
 SSHSAZ44XdSzGAGGIUfgZhLiJFKXDgI4fg6PqRBlwbhlzthaJhs8UJY+DYqGUTEn
 Ld0A/q8rXKb0h4iMuklL68habJeTBFqklK16Rczq5kBqCD26NGPbO4QpasNXHoLg
 LQwk09Da3O3Kwyrj97spE1V+CKLWWdyn21WgcxOsZ+0=

On Thu, Jan 05, 2023 at 04:19:29PM -0500, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
> 
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
> 
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  arch/arm/kernel/sys_oabi-compat.c |   1 +

For arm:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

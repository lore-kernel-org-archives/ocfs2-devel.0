Return-Path: <SRS0=xTLC=KW=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5958FC47089
	for <ocfs2-devel@archiver.kernel.org>; Thu, 27 May 2021 14:37:58 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0565D613DC
	for <ocfs2-devel@archiver.kernel.org>; Thu, 27 May 2021 14:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0565D613DC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14REZDYs024957;
	Thu, 27 May 2021 14:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=Y1CmzOkXgqHmIUJ10Gg3x2s0kwtsg00X09dlFWT34us=;
 b=P6pTBA6yP2iJgljl+KeFqcX2Cz7FJm0C0cY9/xkfjMwA/e+RNHGu0zSxgEuNW1W99ccd
 MS7VS73boYxMzrL9o99E0TxknZysWGiy/PhQfN2ImpILxc/jgXepDq9xletHrZqZctQi
 ca5tTULL+M0M0fetxmiItSlW/2nmdKMgQ6NMRnGdOjjyMdwXTAw57eVcH6FEIp8/tV1G
 6FybrSNOkruQlWT7agxarXQNFMiTxP6ZpSIkoElQ5uR/Bi8yOvYPa4mnzyQcZD44KfRq
 e6e3CwQsebT6klC5gwtr27gk3r4aw3U8hc1BvqO6F3bX/wc268TSVS4GbN3oXnnqFaxX 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 38rne47x9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 May 2021 14:37:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14REZWlM114093;
	Thu, 27 May 2021 14:37:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38pq2wf87d-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 27 May 2021 14:37:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lmH91-0007IR-94; Thu, 27 May 2021 07:37:55 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.carpenter@oracle.com>) id 1lmH8z-0007I5-51
	for ocfs2-devel@oss.oracle.com; Thu, 27 May 2021 07:37:53 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14REaA6U101164
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:37:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3030.oracle.com with ESMTP id 38pr0dn4ma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:37:52 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14REbqlN103757
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:37:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserp3030.oracle.com with ESMTP id 38pr0dn4m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 May 2021 14:37:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14REbffR028351;
	Thu, 27 May 2021 14:37:41 GMT
Received: from kadam (/41.212.42.34) by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Thu, 27 May 2021 14:37:40 +0000
Date: Thu, 27 May 2021 17:37:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Laight <David.Laight@ACULAB.COM>
Message-ID: <20210527143729.GL24442@kadam>
References: <20210526092020.554341-1-chenhuang5@huawei.com>
	<20210526092020.554341-2-chenhuang5@huawei.com>
	<0f03f9b9ff41460db2935e077f7f80c7@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0f03f9b9ff41460db2935e077f7f80c7@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Nathan Lynch <nathanl@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        'Chen Huang' <chenhuang5@huawei.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH -next 2/3] xen: balloon: Replaced
 simple_strtoull() with kstrtoull()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270095
X-Proofpoint-ORIG-GUID: hxh-t_TMw2hBCStWxx8yrJgAQer8zqZo
X-Proofpoint-GUID: hxh-t_TMw2hBCStWxx8yrJgAQer8zqZo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270095

On Thu, May 27, 2021 at 02:10:21PM +0000, David Laight wrote:
> From: Chen Huang
> > Sent: 26 May 2021 10:20
> > 
> > The simple_strtoull() function is deprecated in some situation, since
> > it does not check for the range overflow, use kstrtoull() instead.
> > 
> ...
> > -	target_bytes = simple_strtoull(buf, &endchar, 0) * 1024;
> > +	ret = kstrtoull(buf, 0, &target_bytes);
> > +	if (ret)
> > +		return ret;
> > +	target_bytes *= 1024;
> 
> I'd have thought it was more important to check *endchar
> than overflow.

That's one of the differences between simple_strtoull() and kstrtoull().
The simple_strtoull() will accept a string like "123ABC", but kstrtoull()
will only accept NUL terminated numbers or a newline followed by a NUL
terminator.  Which is fine in this context because users will be doing
"echo 1234 > /sys/foo".

> If you are worried about overflow you need a range check
> before the multiply.

This is probably a case where if the users cause an integer overflow
then they get what they deserve.

regards,
dan carpenter

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

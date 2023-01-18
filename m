Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61793C38147
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ykQYj+pv9+P8ZjZ6rju1wl7RS3EftTEykqSvl803pgU=;
 b=1KcYwbf+kJOD7iqtgteK+CfQpByMRvIjdYFkZg42P+jMXrtmE09hnd2svnHJ0nl267IPMcvWsrYB
   /ozlLQOylU2Ga2Ue20n1WZvFbWVICS6TO5vZr943WXHGN5xfb0E2vPlFUpoqEJ4V+0NoDfzCZpGO
   kLi+zAFNo/r/OuYLmEc6Q+B6RGB27UHTIJlV4bH7WJhaYyqwYcuiOkp8b5eWEPwbz7m3ehPVcr9G
   RZu1rOhmuOeQX3Qwk9T9ZvT86/E/YT/wzDsm/XxlUH74JIUGUroU+Pe8BJC90soOJ/tUIMNjMz6g
   TNU2e+/GmKxXq3yN+omeYZlsk2izqnopoCeBDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ykQYj+pv9+P8ZjZ6rju1wl7RS3EftTEykqSvl803pgU=;
 b=CxB+skemi3CqKEBpFmR4jyJmKn1D38y57s0zs/GEMY3t5+ZA83heGnby5wko3ETVLumSIp5KWBHK
   QN6qVLtUoNMZO4S9f9z+22MzHF+aHq9GQLSnOmRnAQpN4bByYhdYnjXivxyv1BkcloetuQlcflAY
   m8lD/F6lwti75ZC/ARD0MkW4DzpTg268IwP1CpGRhDiU6ChUr3f8pmNc2tNtIbLA4PbVP0f+ChYm
   xS/y9mQ0JR+99MWWQyvdOKpYBHqal4wJhXk4SX99Ydxkc8/GO9WbL5+4HS9sV7VSZBcdZygDV00D
   hdqZqKif+P63EFnWbf4gnUX0f+q4FsyTnGKzQg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROP00DS19GZXWA0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 21:10:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1674076194; bh=d6RE1SW3HYvTygWxh6wXuWPHqFU3wzaUIYzQ7eszNj4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=2M8BmoizjVavzS0EgfAn0+yFOCA8/vNzivZSCs60Ci62Lub6qkp49nZ2ZrMR2Kuhz
 nf0cr0ilX1wPBvKHtxtXAX3PlYvcVdMNDUHNCdey30hcQQCh/qjWYh9IF+YBROf2A/
 ZARd54bkP0OLZRGOJqrWPX9q7jW7ImUfWpwlDpw4=
Date: Wed, 18 Jan 2023 13:09:53 -0800
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230118130953.b5a305ac2a6eabac9179d025@linux-foundation.org>
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=207
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=48 mlxlogscore=529 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180179
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page v3
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 7iuJPPSmRwcIyt4NZr3kY1kGNpgEqHnC
X-Proofpoint-ORIG-GUID: 7iuJPPSmRwcIyt4NZr3kY1kGNpgEqHnC
Reporting-Meta:
 AAHKfmqoUvcOfzfpqUFAByxd9ebABNESxoI8RRZScHUIexrD/DqZC1LFrQh0wKaB
 duwzg4qbnqBJNwYKdK1ouFPlIp254UXxdxDl/jAYZA/+XF0GVCGiYinBkd1NteaE
 exk+q5TCUD0nT7R1qoz3fE5r0RsQrYRLaS5TO3WFXQOoN5+sGADbQy+6QHplbhX+
 1i78DLuqDH2UL9XiH5CrvVYnOoyQSn6gJVyMXICg8RFU77A8AikoK7M07wIll/pS
 J/Rs0agZjUFfJ+o4TxVMv0YeUuDoRUiEXL0N1aWHriPVL8qyg/G5MCC5G72IQVrR
 Lw/OVY5/nkQKlxuIlCZIpfmn33c8KC+Et4afE1EMQrlG+Y45U0J3CjUur6J08fpq
 35Xb8QDD2ZYNzaFfpQFkdDvhJXGnXteEj3QHdfFBQy0XN1MnSVQuOx2XkWeogPPn
 BnYTqkAhWumOgruR06Ufq2LFfnbbY++qzIauIUHXufaih3gmka7D41X10wlEQqal
 OXz/i08OwFTD4PrcM0FnI6dHwhrqqHNw9sHvsvgsAtU=

On Wed, 18 Jan 2023 18:30:20 +0100 Christoph Hellwig <hch@lst.de> wrote:

> this series removes most users of the write_one_page API.  These helpers
> internally call ->writepage which we are gradually removing from the
> kernel.

I grabbed these.  If Stephen's duplicated patch check tells me that they're
also in the VFS tree, I'll drop them again.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

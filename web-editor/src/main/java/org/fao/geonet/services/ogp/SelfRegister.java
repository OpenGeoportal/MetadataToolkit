package org.fao.geonet.services.ogp;

import jeeves.server.context.ServiceContext;
import jeeves.services.ReadWriteController;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.fao.geonet.domain.*;
import org.fao.geonet.domain.responses.OkResponse;
import org.fao.geonet.exceptions.BadInputEx;
import org.fao.geonet.exceptions.BadParameterEx;
import org.fao.geonet.exceptions.MissingParameterEx;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.fao.geonet.repository.GroupRepository;
import org.fao.geonet.repository.UserGroupRepository;
import org.fao.geonet.repository.UserRepository;
import org.fao.geonet.services.ogp.beans.FailureResult;
import org.fao.geonet.services.ogp.beans.RegisterForm;
import org.fao.geonet.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.UUID;

/**
 * Created by JuanLuis on 26/03/2015.
 */
@Controller("ogp.create.account")
@ReadWriteController
public class SelfRegister {
    private static final String USER_ALREADY_EXISTS_ERROR = "errorEmailAddressAlreadyRegistered";

    @Autowired
    private GeonetworkDataDirectory dataDir;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserGroupRepository userGroupRepository;
    @Autowired
    private GroupRepository groupRepository;



    @RequestMapping(value = "/{lang}/ogp.create.account", produces = {
            MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})

    public @ResponseBody OkResponse registerUser(@RequestBody RegisterForm form) {

        OkResponse response = new OkResponse();
        validateForm(form);

        // Check if user already exists
        if (userRepository.findOneByEmail(form.getEmail()) != null) {
            response.setValue(USER_ALREADY_EXISTS_ERROR);
            return response;
        }

        // Add user to database. Set Editor profile
        String passwordHash = PasswordUtil.encode(ServiceContext.get(), form.getPassword());
        User user = new User().setKind("")
                .setName(form.getName())
                .setOrganisation(form.getOrg())
                .setProfile(Profile.Editor)
                .setSurname(form.getSurname())
                .setUsername(form.getEmail());
        user.getSecurity().setPassword(passwordHash);
        user.getEmailAddresses().add(form.getEmail());
        user.getAddresses().add(new Address().setAddress(form.getAddress()).setCountry(form.getCountry()).setCity(form.getCity()).setState(form.getState()).setZip(form.getZip()));
        userRepository.save(user);


        String groupName = cleanGroupName(form.getEmail());
        Group group = new Group().setEmail(form.getEmail()).setDescription("Private group for user " + form.getEmail())
                .setName(groupName);
        groupRepository.save(group);
        UserGroup userGroup = new UserGroup().setUser(user).setGroup(group).setProfile(Profile.Editor);
        userGroupRepository.save(userGroup);

        return response;
    }

    @ExceptionHandler(Exception.class)
    public @ResponseBody FailureResult handleException(Exception ex, HttpServletResponse response) {
        FailureResult result = new FailureResult();
        result.setId(UUID.randomUUID().toString());
        result.setClazz(ex.getClass().getSimpleName());
        // result.setStack(ExceptionUtils.getStackTrace(ex));
        result.setService("ogp.create.account");
        result.setMessage(ex.getClass().getSimpleName() + ": " + ex.getMessage());
        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());

        return result;
    }

    private void validateForm(RegisterForm form) {
        if (form == null) {
            throw new MissingParameterEx("form");
        }
        getParam("email", form.getEmail());
        getParam("password", form.getPassword());
        getParam("name", form.getName());
        getParam("surname", form.getSurname());
        getParam("org", form.getOrg());
    }

    public static String getParam(String name, String value) throws BadInputEx
    {
        if (value == null)
            throw new MissingParameterEx(name);


        String content = StringUtils.trimToEmpty(value);

        if (content.length() == 0)
            throw new BadParameterEx(name, value);

        return value;
    }

    private String cleanGroupName(String groupName) {
        return groupName.replace('@', '_').replace('.', '_');
    }

}
